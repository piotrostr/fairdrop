// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../contracts/FairDrop.sol";
import "../contracts/IWorldID.sol";

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

contract FairDropTest is Test {
  FairDrop public fairDrop;
  MockWorldID public mockWorldID;

  address public constant ALICE = address(0x1);
  address public constant BOB = address(0x2);

  function setUp() public {
    mockWorldID = new MockWorldID();
    fairDrop = new FairDrop(
      IWorldID(address(mockWorldID)), "test_app_id", "test_action_id"
    );
  }

  function testConstructor() public view {
    assertTrue(
      address(fairDrop.worldId()) == address(mockWorldID),
      "WorldID address should match"
    );
  }

  function testVerifyAndExecute() public {
    uint256 root = 123;
    uint256 nullifierHash = 456;
    uint256[8] memory proof;

    vm.prank(ALICE);
    fairDrop.verifyAndExecute(ALICE, root, nullifierHash, proof);

    assertTrue(fairDrop.isVerified(ALICE), "Alice should be verified");
  }

  function testCannotVerifyTwice() public {
    uint256 root = 123;
    uint256 nullifierHash = 456;
    uint256[8] memory proof;

    vm.prank(ALICE);
    fairDrop.verifyAndExecute(ALICE, root, nullifierHash, proof);

    vm.expectRevert(
      abi.encodeWithSelector(
        FairDrop.DuplicateNullifier.selector, nullifierHash
      )
    );
    vm.prank(ALICE);
    fairDrop.verifyAndExecute(ALICE, root, nullifierHash, proof);
  }

  function testDifferentUsersCanVerify() public {
    uint256 root = 123;
    uint256[8] memory proof;

    vm.prank(ALICE);
    fairDrop.verifyAndExecute(ALICE, root, 456, proof);

    vm.prank(BOB);
    fairDrop.verifyAndExecute(BOB, root, 789, proof);

    assertTrue(fairDrop.isVerified(ALICE), "Alice should be verified");
    assertTrue(fairDrop.isVerified(BOB), "Bob should be verified");
  }

  function testIsVerified() public {
    assertFalse(
      fairDrop.isVerified(ALICE), "Alice should not be verified initially"
    );

    uint256 root = 123;
    uint256 nullifierHash = 456;
    uint256[8] memory proof;

    vm.prank(ALICE);
    fairDrop.verifyAndExecute(ALICE, root, nullifierHash, proof);

    assertTrue(
      fairDrop.isVerified(ALICE), "Alice should be verified after execution"
    );
    assertFalse(fairDrop.isVerified(BOB), "Bob should not be verified");
  }
}
