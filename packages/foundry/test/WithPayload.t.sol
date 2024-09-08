// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../contracts/FairDrop.sol";

contract FairDropOptimismTest is Test {
  FairDrop public fairDrop;
  MockWorldID public mockWorldID;
  MockWormholeRelayer public mockWormholeRelayer;

  address constant FAIRDROP_ADDRESS = 0x859A661A05C3F2FBec2f08a9D2656F0092b3Ce7a;
  address constant SENDER = 0x1b4cd36EAA7310E1e5Ae7Ca128F12bE3D40C8694;

  function setUp() public {
    // Fork Optimism mainnet
    vm.createSelectFork("optimism");

    // Deploy mock contracts
    mockWorldID = new MockWorldID();
    mockWormholeRelayer = new MockWormholeRelayer();

    // Use the existing FairDrop contract on Optimism
    fairDrop = FairDrop(FAIRDROP_ADDRESS);
  }

  function testVerifyAndPropagateReal() public {
    vm.skip(true);
    // Prepare the inputs
    address signal = SENDER;
    uint256 root =
      21586588502930903881849839602671265803101890569688505413221772255789699873089;
    uint256 nullifierHash =
      13893138250131921740408929495793037376980871264533084259530405383665546116297;
    uint256[8] memory proof = [
      442191580517615092022473964054710862868601527221847401587732553667404809491,
      13009987470428252925931722949548663160266748400273418140409736761487372999901,
      2539070977723262824381312381800389678811089009913537214709611533060732593658,
      185296169078644388229720947478409899557997835814671091400357294315783258465,
      7482994745129265572573766618465370625429114027542122091031146067454515448349,
      7660101419749295202836852090827642836175475351494470676523226919410406310899,
      16984757176706105786056544799823321957945689792232167661403631515548419760869,
      10965156287749982817029515474814371928889441193803514031553948544645051509395
    ];

    // Set up the sender
    vm.prank(SENDER);

    // Call the function and expect it to revert
    fairDrop.verifyAndPropagate(signal, root, nullifierHash, proof);

    // If it doesn't revert, let's check the contract state
    (bool success, bytes memory result) = address(fairDrop).call(
      abi.encodeWithSignature(
        "verifyAndPropagate(address,uint256,uint256,uint256[8])",
        signal,
        root,
        nullifierHash,
        proof
      )
    );
    require(success, "Call failed");

    emit log_bytes(result);

    // Additional checks
    emit log_named_uint("Receiver Chain ID", fairDrop.receiverChainId());
    emit log_named_address("Receiver Address", fairDrop.receiverAddress());
  }
}

contract MockWorldID {
  function verifyProof(
    uint256,
    uint256,
    uint256,
    uint256,
    uint256,
    uint256[8] calldata
  ) external pure { }
}

contract MockWormholeRelayer {
  function quoteEVMDeliveryPrice(
    uint16,
    uint256,
    uint256
  ) external pure returns (uint256, uint256) {
    return (1 ether, 0);
  }

  function sendPayloadToEvm(
    uint16,
    address,
    bytes memory,
    uint256,
    uint256
  ) external payable returns (uint64) {
    return 0;
  }
}
