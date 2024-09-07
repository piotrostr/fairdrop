// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { ByteHasher } from "./ByteHasher.sol";
import { IWorldID } from "./IWorldID.sol";
import { IWormholeRelayer } from
  "wormhole-solidity-sdk/interfaces/IWormholeRelayer.sol";
import { IWormholeReceiver } from
  "wormhole-solidity-sdk/interfaces/IWormholeReceiver.sol";

contract FairDrop {
  mapping(address => bool) public verified;

  using ByteHasher for bytes;

  error DuplicateNullifier(uint256 nullifierHash);
  error ReceiverAlreadySet();

  /// @dev The World ID instance that will be used for verifying proofs
  IWorldID public immutable worldId;

  /// @dev The contract's external nullifier hash
  uint256 internal immutable externalNullifier;

  /// @dev The World ID group ID (always 1)
  uint256 internal immutable groupId = 1;

  /// @dev Whether a nullifier hash has been used already. Used to guarantee an
  //action is only performed once by a single person
  /// nullifier hash <=> hash(person's identity) through $WLD ID
  mapping(uint256 => bool) internal nullifierHashes;

  /// @param nullifierHash The nullifier hash for the verified proof
  /// @dev A placeholder event that is emitted when a user successfully verifies with World ID
  event Verified(uint256 nullifierHash);

  event SentForDelivery(
    uint256 timestamp, uint256 deliveryQuote, uint256 payloadLength
  );
  event ReceiverSet(uint16 chainId, address receiverAddress);

  uint16 public chainId;
  uint16 public receiverChainId;
  address public receiverAddress;

  IWormholeRelayer public immutable wormholeRelayer;

  // haven't messed with this param yet
  uint256 constant GAS_LIMIT = 100_000;

  constructor(
    address _worldId,
    string memory _appId,
    string memory _actionId,
    address _wormholeRelayer,
    uint16 _chainId
  ) {
    worldId = IWorldID(_worldId);
    wormholeRelayer = IWormholeRelayer(_wormholeRelayer);

    externalNullifier = abi.encodePacked(
      abi.encodePacked(_appId).hashToField(), _actionId
    ).hashToField();

    chainId = _chainId;
  }

  // @dev Set the receiver address, for now only one, this should be extended
  // in the future
  // my intuition is to create a registry contract that will store the
  // addresses and allow for separate transactions whenever applicable
  // so like ~8 mainnet addresses for 8 different chains, configurable
  // in the frontend
  function setReceiver(
    uint16 _receiverChainId,
    address _receiverAddress
  ) external {
    if (receiverAddress != address(0)) revert ReceiverAlreadySet();
    receiverChainId = _receiverChainId;
    receiverAddress = _receiverAddress;
    emit ReceiverSet(_receiverChainId, _receiverAddress);
  }

  function verifyAndPropagate(
    address signal,
    uint256 root,
    uint256 nullifierHash,
    uint256[8] calldata proof
  ) public payable {
    require(receiverAddress != address(0), "Receiver not set");

    if (nullifierHashes[nullifierHash]) {
      revert DuplicateNullifier(nullifierHash);
    }

    worldId.verifyProof(
      root,
      groupId,
      abi.encodePacked(signal).hashToField(),
      nullifierHash,
      externalNullifier,
      proof
    );

    nullifierHashes[nullifierHash] = true;
    verified[msg.sender] = true;

    emit Verified(nullifierHash);

    bytes memory payload = abi.encode(msg.sender, nullifierHash);
    uint256 deliveryQuote = getDeliveryQuote(0);

    wormholeRelayer.sendPayloadToEvm{ value: deliveryQuote }(
      receiverChainId,
      receiverAddress,
      payload,
      0, // no receiverValue
      GAS_LIMIT
    );

    emit SentForDelivery(block.timestamp, deliveryQuote, payload.length);
  }

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
  error VerifierAlreadySet();

  uint16 public chainId;
  uint16 public verifierChainId;
  address public verifierAddress;
  uint16 public constant OPTIMISM_CHAIN_ID = 10;

  mapping(address => bool) public verifiedUsers;
  mapping(uint256 => bool) public usedNullifiers;

  event VerificationPropagated(
    uint256 timestamp, address user, uint256 nullifierHash
  );
  event VerifierSet(uint16 chainId, address verifierAddress);

  constructor(
    uint16 _chainId
  ) {
    chainId = _chainId;
  }

  function setVerifier(
    uint16 _verifierChainId,
    address _verifierAddress
  ) external {
    if (verifierAddress != address(0)) revert VerifierAlreadySet();
    verifierChainId = _verifierChainId;
    verifierAddress = _verifierAddress;
    emit VerifierSet(_verifierChainId, _verifierAddress);
  }

  function receiveWormholeMessages(
    bytes memory payload,
    bytes[] memory, // additionalMeta
    bytes32 sourceAddress,
    uint16 sourceChain,
    bytes32 // deliveryHash
  ) external payable {
    require(verifierAddress != address(0), "Verifier not set");
    address parsedVerifierAddress = address(uint160(uint256(sourceAddress)));
    require(
      parsedVerifierAddress == verifierAddress, "Invalid verifier address"
    );
    require(
      sourceChain == OPTIMISM_CHAIN_ID,
      "Invalid verifier chain ID, need Optimism chain ID"
    );

    (address user, uint256 nullifierHash) =
      abi.decode(payload, (address, uint256));

    require(!usedNullifiers[nullifierHash], "Sybil Alert!");

    verifiedUsers[user] = true;
    usedNullifiers[nullifierHash] = true;

    emit VerificationPropagated(block.timestamp, user, nullifierHash);
  }

  function isVerified(
    address user
  ) public view returns (bool) {
    return verifiedUsers[user];
  }
}
