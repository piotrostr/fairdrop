//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contracts/FairDrop.sol";
import "../contracts/FairDropSatellite.sol";
import "./DeployHelpers.s.sol";
import { DeployFairDrop } from "./00_deploy_fair_drop.s.sol";
import { DeployFairDropSatellite } from "./01_deploy_satellite.s.sol";

contract DeployScript is ScaffoldETHDeploy {
  function run() external {
    if (block.chainid == 10) {
      // Deploy on Optimism
      DeployFairDrop deployFairDrop = new DeployFairDrop();
      deployFairDrop.run();
      console.logString("FairDrop deployed on Optimism");
    } else if (block.chainid == 42161) {
      // Deploy on Arbitrum
      DeployFairDropSatellite deployFairDropSatellite =
        new DeployFairDropSatellite();
      deployFairDropSatellite.run();
      console.logString("FairDropSatellite deployed on Arbitrum");

      // Set cross-chain information
      address fairDropAddress = getDeploymentAddress("FairDrop");
      address fairDropSatelliteAddress =
        getDeploymentAddress("FairDropSatellite");

      if (
        fairDropAddress != address(0) && fairDropSatelliteAddress != address(0)
      ) {
        FairDrop fairDrop = FairDrop(fairDropAddress);
        FairDropSatellite fairDropSatellite =
          FairDropSatellite(fairDropSatelliteAddress);

        fairDrop.setReceiver(42161, fairDropSatelliteAddress);
        fairDropSatellite.setVerifier(10, fairDropAddress);

        console.logString("Cross-chain information set successfully");
      } else {
        console.logString(
          "Unable to set cross-chain information. Make sure both contracts are deployed."
        );
      }
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
