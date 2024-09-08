// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { IWormholeReceiver } from
  "wormhole-solidity-sdk/interfaces/IWormholeReceiver.sol";

/// @title FairDropSatellite
/// @notice A contract that receives messages from the FairDrop verifier and
/// lives / on any L2 EVM-compatible chain
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
