// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contracts/FairDrop.sol";
import "../contracts/FairDropSatellite.sol";
import "./DeployHelpers.s.sol";
import { DeployFairDrop } from "./00_deploy_fair_drop.s.sol";
import { DeployFairDropSatellite } from "./01_deploy_satellite.s.sol";

contract DeployScript is ScaffoldETHDeploy {
  address public fairDropAddress;
  address public fairDropSatelliteAddress;

  function run() external {
    if (block.chainid == 10) {
      // Deploy on Optimism
      DeployFairDrop deployFairDrop = new DeployFairDrop();
      deployFairDrop.run();
      fairDropAddress = getDeploymentAddress("FairDrop");
      console.logString(
        string.concat(
          "FairDrop deployed on Optimism at: ", vm.toString(fairDropAddress)
        )
      );
    } else if (block.chainid == 42161) {
      // Deploy on Arbitrum
      DeployFairDropSatellite deployFairDropSatellite =
        new DeployFairDropSatellite();
      deployFairDropSatellite.run();
      fairDropSatelliteAddress = getDeploymentAddress("FairDropSatellite");
      console.logString(
        string.concat(
          "FairDropSatellite deployed on Arbitrum at: ",
          vm.toString(fairDropSatelliteAddress)
        )
      );
    } else {
      revert("Unsupported chain ID");
    }
  }

  function getDeploymentAddress(
    string memory name
  ) internal view returns (address) {
    for (uint256 i = 0; i < deployments.length; i++) {
      if (
        keccak256(abi.encodePacked(deployments[i].name))
          == keccak256(abi.encodePacked(name))
      ) {
        return deployments[i].addr;
      }
    }
    return address(0);
  }
}
