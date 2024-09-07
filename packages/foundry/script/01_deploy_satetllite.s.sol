// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contracts/FairDrop.sol";
import "./DeployHelpers.s.sol";

contract DeployFairDropSatellite is ScaffoldETHDeploy {
  function run() external ScaffoldEthDeployerRunner {
    // Check if we're on Arbitrum
    require(block.chainid == 42161, "Must be deployed on Arbitrum");

    console.log("deployer: ", msg.sender);

    uint16 chainId = uint16(block.chainid);

    FairDropSatellite fairDropSatellite = new FairDropSatellite(chainId);

    console.logString(
      string.concat(
        "FairDropSatellite deployed at: ",
        vm.toString(address(fairDropSatellite))
      )
    );

    deployments.push(
      Deployment("FairDropSatellite", address(fairDropSatellite))
    );
  }
}
