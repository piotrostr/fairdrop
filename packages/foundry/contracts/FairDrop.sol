// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { ByteHasher } from "./ByteHasher.sol";
import { IWorldID } from "./IWorldID.sol";
import { IWormholeRelayer } from
  "wormhole-solidity-sdk/interfaces/IWormholeRelayer.sol";
import { IWormholeReceiver } from
  "wormhole-solidity-sdk/interfaces/IWormholeReceiver.sol";

// this could probably be broken into separate contracts for supporting
// solely Optimism verification and neater design
contract FairDrop {
  mapping(address => bool) verified;

  using ByteHasher for bytes;

  error DuplicateNullifier(uint256 nullifierHash);

  /// @dev The World ID instance that will be used for verifying proofs
  IWorldID public immutable worldId;

  /// @dev The contract's external nullifier hash
  uint256 internal immutable externalNullifier;

  /// @dev The World ID group ID (always 1)
  uint256 internal immutable groupId = 1;

  /// @dev Whether a nullifier hash has been used already. Used to guarantee an action is only performed once by a single person
  mapping(uint256 => bool) internal nullifierHashes;

  /// @param nullifierHash The nullifier hash for the verified proof
  /// @dev A placeholder event that is emitted when a user successfully verifies with World ID
  event Verified(uint256 nullifierHash);

  event SentForDelivery(
    uint256 timestamp, uint256 deliveryQuote, uint256 payloadLength
  );

  uint16 public chainId;
  uint16 public receiverChainId;
  address public receiverAddress;

  IWormholeRelayer public immutable wormholeRelayer;

  // haven't messed with this param yet
  uint256 constant GAS_LIMIT = 100_000;

  /// @param _worldId The WorldID router that will verify the proofs
  /// @param _appId The World ID app ID
  /// @param _actionId The World ID action ID
  // @param _wormhole The Wormhole contract address
  // @param _chainId The chain ID of the FairDrop contract
  // @param _receiverAddress The address of the receiver contract (foreign chain)
  // @param _receiverChainId The chain ID of the receiver chain
  constructor(
    address _worldId,
    string memory _appId,
    string memory _actionId,
    address _wormholeRelayer,
    uint16 _chainId,
    address _receiverAddress,
    uint16 _receiverChainId
  ) {
    worldId = IWorldID(_worldId);
    wormholeRelayer = IWormholeRelayer(_wormholeRelayer);

    externalNullifier = abi.encodePacked(
      abi.encodePacked(_appId).hashToField(), _actionId
    ).hashToField();

    chainId = _chainId;
    receiverAddress = _receiverAddress;
    receiverChainId = _receiverChainId;
  }

  /// @param signal An arbitrary input from the user, usually the user's wallet address (check README for further details)
  /// @param root The root of the Merkle tree (returned by the JS widget).
  /// @param nullifierHash The nullifier hash for this proof, preventing double signaling (returned by the JS widget).
  /// @param proof The zero-knowledge proof that demonstrates the claimer is registered with World ID (returned by the JS widget).
  /// @dev Feel free to rename this method however you want! We've used `claim`, `verify` or `execute` in the past.
  function verifyAndPropagate(
    address signal,
    uint256 root,
    uint256 nullifierHash,
    uint256[8] calldata proof
  ) public {
    // First, we make sure this person hasn't done this before
    if (nullifierHashes[nullifierHash]) {
      revert DuplicateNullifier(nullifierHash);
    }

    // We now verify the provided proof is valid and the user is verified by World ID
    worldId.verifyProof(
      root,
      groupId,
      abi.encodePacked(signal).hashToField(),
      nullifierHash,
      externalNullifier,
      proof
    );

    // Update proof of uniqueness and mark the user as verified
    nullifierHashes[nullifierHash] = true;
    verified[msg.sender] = true;

    emit Verified(nullifierHash);

    // Propagate the verified signal to the receiver chain
    // in production, it is highly advised there is some encryption mechanism
    // possibly introduced here, it seems a bit insecure
    // there is the verification of the VM, but if the proof is interceipted
    // at the web2 level, it could be a front-run attack opportunity if man in
    // the middle is there
    bytes memory payload = abi.encodePacked(msg.sender, nullifierHash);
    // Get a quote for the cost of gas for delivery
    // receiverValue param is 0 since we are not sending any ether
    uint256 deliveryQuote = getDeliveryQuote(0);

    // Send the message
    wormholeRelayer.sendPayloadToEvm{ value: deliveryQuote }(
      receiverChainId,
      receiverAddress,
      abi.encode(payload),
      0, // no receiverValue
      GAS_LIMIT
    );
    // get timestamp here
    emit SentForDelivery(block.timestamp, deliveryQuote, payload.length);
  }

  /// @param receiverValue The value to send to the receiver contract
  /// @dev public view method for the frontend to get the get the quote
  /// before constructing the tx
  function getDeliveryQuote(
    uint256 receiverValue
  ) public view returns (uint256 cost) {
    (cost,) = wormholeRelayer.quoteEVMDeliveryPrice(
      receiverChainId, receiverValue, GAS_LIMIT
    );
  }

  function isVerified(
    address _address
  ) public view returns (bool) {
    return verified[_address];
  }
}

contract FairDropSatellite is IWormholeReceiver {
  IWormholeReceiver public immutable wormholeReceiver;
  uint16 public chainId;
  uint16 public verifierChainId;
  address public verifierAddress;
  uint16 public optimismChainId = 10;

  mapping(address => bool) public verifiedUsers;
  mapping(uint256 => bool) public usedNullifiers;

  event VerificationPropagated(
    uint256 timestamp, address user, uint256 nullifierHash
  );

  constructor(
    uint16 _chainId,
    uint16 _verifierChainId,
    address _verifierAddress
  ) {
    chainId = _chainId;
    verifierChainId = _verifierChainId;
    verifierAddress = _verifierAddress;
  }

  function receiveWormholeMessages(
    bytes memory payload,
    bytes[] memory, // additionalMeta
    bytes32 sourceAddress,
    uint16 sourceChain,
    bytes32 // deliveryHash
  ) external payable {
    address parsedVerifierAddress = address(uint160(uint256(sourceAddress)));
    require(
      parsedVerifierAddress == verifierAddress, "Invalid verifier address"
    );
    require(
      sourceChain == optimismChainId,
      "Invalid verifier chain ID, need Optimism chain ID"
    );

    // haven't checked this yet
    // bytes32 verifierDeliveryHash =
    //   keccak256(abi.encodePacked(payload, sourceAddress, sourceChain));
    // require(verifierDeliveryHash == deliveryHash, "Invalid delivery hash");

    (address user, uint256 nullifierHash) =
      abi.decode(payload, (address, uint256));

    require(!usedNullifiers[nullifierHash], "Nullifier already used");

    verifiedUsers[user] = true;
    usedNullifiers[nullifierHash] = true;

    emit VerificationPropagated(block.timestamp, user, nullifierHash);
  }

  // Function to check if a user is verified
  function isVerified(
    address user
  ) public view returns (bool) {
    return verifiedUsers[user];
  }
}
