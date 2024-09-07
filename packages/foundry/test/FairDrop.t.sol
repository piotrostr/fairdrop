// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../contracts/FairDrop.sol";
import "../contracts/IWorldID.sol";
import "wormhole-solidity-sdk/interfaces/IWormholeRelayer.sol";
import "wormhole-solidity-sdk/interfaces/IWormholeReceiver.sol";

contract MockWorldID is IWorldID {
  function verifyProof(
    uint256 root,
    uint256 groupId,
    uint256 signalHash,
    uint256 nullifierHash,
    uint256 externalNullifierHash,
    uint256[8] calldata proof
  ) external pure override {
    // This is a mock implementation, so we'll just return without doing any actual verification
  }
}

// Mock Wormhole Relayer
contract MockWormholeRelayer {
  uint256 public deliveryQuote;
  uint16 public lastTargetChain;
  address public lastTargetAddress;
  bytes public lastPayload;

  function setDeliveryQuote(
    uint256 _quote
  ) external {
    deliveryQuote = _quote;
  }

  function sendPayloadToEvm(
    uint16 targetChain,
    address targetAddress,
    bytes memory payload,
    uint256,
    uint256
  ) external payable returns (uint64) {
    require(msg.value >= deliveryQuote, "Insufficient payment");
    lastTargetChain = targetChain;
    lastTargetAddress = targetAddress;
    lastPayload = payload;

    // Debug: Log the received payload
    console.log("MockWormholeRelayer received payload:");
    console.logBytes(payload);

    return 1; // Return a dummy sequence number
  }

  function quoteEVMDeliveryPrice(
    uint16, // targetChain
    uint256, // receiverValue
    uint256 // gasLimit
  ) external view returns (uint256 cost, uint256 messageFee) {
    return (deliveryQuote, 0);
  }

  // Other methods skipped for brevity
}

contract FairDropTestExtended is Test {
  FairDrop public fairDrop;
  FairDropSatellite public fairDropSatellite;
  MockWorldID public mockWorldID;
  MockWormholeRelayer public mockWormholeRelayer;

  address public constant ALICE = address(0x1);
  address public constant BOB = address(0x2);
  uint16 constant CHAIN_ID_OPTIMISM = 10;
  uint16 constant CHAIN_ID_ARBITRUM = 42161;

  function setUp() public {
    mockWorldID = new MockWorldID();
    mockWormholeRelayer = new MockWormholeRelayer();

    // Deploy FairDrop
    fairDrop = new FairDrop(
      address(mockWorldID),
      "test_app_id",
      "test_action_id",
      address(mockWormholeRelayer),
      CHAIN_ID_OPTIMISM
    );

    // Deploy FairDropSatellite
    fairDropSatellite = new FairDropSatellite(CHAIN_ID_ARBITRUM);

    // Set receiver in FairDrop
    fairDrop.setReceiver(CHAIN_ID_ARBITRUM, address(fairDropSatellite));

    // Set verifier in FairDropSatellite
    fairDropSatellite.setVerifier(CHAIN_ID_OPTIMISM, address(fairDrop));
  }

  function testVerifyAndPropagate() public {
    uint256 root = 123;
    uint256 nullifierHash = 456;
    uint256[8] memory proof;
    uint256 deliveryQuote = 1 ether;

    mockWormholeRelayer.setDeliveryQuote(deliveryQuote);

    vm.deal(ALICE, 2 ether); // Give ALICE some ETH
    vm.prank(ALICE);
    fairDrop.verifyAndPropagate{ value: deliveryQuote }(
      ALICE, root, nullifierHash, proof
    );

    assertTrue(fairDrop.isVerified(ALICE), "Alice should be verified");
    assertEq(
      mockWormholeRelayer.lastTargetChain(),
      CHAIN_ID_ARBITRUM,
      "Wrong target chain"
    );
    assertEq(
      mockWormholeRelayer.lastTargetAddress(),
      address(fairDropSatellite),
      "Wrong target address"
    );

    // Debug: Print out the raw payload
    console.logBytes(mockWormholeRelayer.lastPayload());

    // Debug: Print out the length of the payload
    console.log("Payload length:", mockWormholeRelayer.lastPayload().length);

    // Decode the payload and check its contents
    (address decodedUser, uint256 decodedNullifierHash) =
      abi.decode(mockWormholeRelayer.lastPayload(), (address, uint256));

    // Debug: Print out the decoded values
    console.log("Decoded user address:", decodedUser);
    console.log("Expected user address (ALICE):", ALICE);
    console.log("Decoded nullifierHash:", decodedNullifierHash);
    console.log("Expected nullifierHash:", nullifierHash);

    // Debug: Try to decode just the first 32 bytes as an address
    address firstAddressInPayload =
      address(uint160(uint256(bytes32(mockWormholeRelayer.lastPayload()))));
    console.log("First address in payload:", firstAddressInPayload);

    assertEq(decodedUser, ALICE, "Wrong user in payload");
    assertEq(
      decodedNullifierHash, nullifierHash, "Wrong nullifierHash in payload"
    );
  }

  function testGetDeliveryQuote() public {
    uint256 expectedQuote = 0.5 ether;
    mockWormholeRelayer.setDeliveryQuote(expectedQuote);

    uint256 actualQuote = fairDrop.getDeliveryQuote(0);
    assertEq(actualQuote, expectedQuote, "Delivery quote mismatch");
  }

  function testReceiveWormholeMessages() public {
    uint256 nullifierHash = 789;
    bytes memory payload = abi.encode(BOB, nullifierHash);

    vm.prank(address(mockWormholeRelayer));
    fairDropSatellite.receiveWormholeMessages(
      payload,
      new bytes[](0),
      bytes32(uint256(uint160(address(fairDrop)))),
      CHAIN_ID_OPTIMISM,
      bytes32(0)
    );

    assertTrue(
      fairDropSatellite.isVerified(BOB), "Bob should be verified on satellite"
    );
    assertTrue(
      fairDropSatellite.usedNullifiers(nullifierHash),
      "Nullifier should be marked as used"
    );
  }

  function testCannotUseNullifierTwice() public {
    uint256 nullifierHash = 101112;
    bytes memory payload = abi.encode(BOB, nullifierHash);

    vm.prank(address(mockWormholeRelayer));
    fairDropSatellite.receiveWormholeMessages(
      payload,
      new bytes[](0),
      bytes32(uint256(uint160(address(fairDrop)))),
      CHAIN_ID_OPTIMISM,
      bytes32(0)
    );

    vm.expectRevert("Sybil Alert!");
    vm.prank(address(mockWormholeRelayer));
    fairDropSatellite.receiveWormholeMessages(
      payload,
      new bytes[](0),
      bytes32(uint256(uint160(address(fairDrop)))),
      CHAIN_ID_OPTIMISM,
      bytes32(0)
    );
  }

  function testCannotReceiveFromWrongChain() public {
    uint256 nullifierHash = 131415;
    bytes memory payload = abi.encode(ALICE, nullifierHash);

    vm.expectRevert("Invalid verifier chain ID, need Optimism chain ID");
    vm.prank(address(mockWormholeRelayer));
    fairDropSatellite.receiveWormholeMessages(
      payload,
      new bytes[](0),
      bytes32(uint256(uint160(address(fairDrop)))),
      CHAIN_ID_ARBITRUM, // Wrong chain ID
      bytes32(0)
    );
  }

  function testCannotReceiveFromWrongVerifier() public {
    uint256 nullifierHash = 161718;
    bytes memory payload = abi.encode(ALICE, nullifierHash);

    vm.expectRevert("Invalid verifier address");
    vm.prank(address(mockWormholeRelayer));
    fairDropSatellite.receiveWormholeMessages(
      payload,
      new bytes[](0),
      bytes32(uint256(uint160(address(0x5678)))), // Wrong verifier address
      CHAIN_ID_OPTIMISM,
      bytes32(0)
    );
  }

  function testManualPayloadEncodingDecoding() public pure {
    address testAddress = address(0x1234567890123456789012345678901234567890);
    uint256 testNullifierHash = 123456789;

    bytes memory encodedPayload = abi.encode(testAddress, testNullifierHash);

    (address decodedAddress, uint256 decodedNullifierHash) =
      abi.decode(encodedPayload, (address, uint256));

    assertEq(
      decodedAddress,
      testAddress,
      "Address mismatch in manual encoding/decoding"
    );
    assertEq(
      decodedNullifierHash,
      testNullifierHash,
      "NullifierHash mismatch in manual encoding/decoding"
    );
  }
}
