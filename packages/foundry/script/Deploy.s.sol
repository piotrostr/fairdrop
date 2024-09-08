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

      // Set receiver information if available
      address storedSatelliteAddress =
        vm.envAddress("FAIRDROP_SATELLITE_ADDRESS");
      if (storedSatelliteAddress != address(0)) {
        FairDrop(fairDropAddress).setReceiver(42161, storedSatelliteAddress);
        console.logString("Receiver set for FairDrop");
      } else {
        console.logString(
          "FairDropSatellite address not available. Please set it manually later."
        );
      }
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

      // Set verifier information if available
      address storedFairDropAddress = vm.envAddress("FAIRDROP_ADDRESS");
      if (storedFairDropAddress != address(0)) {
        FairDropSatellite(fairDropSatelliteAddress).setVerifier(
          10, storedFairDropAddress
        );
        console.logString("Verifier set for FairDropSatellite");
      } else {
        console.logString(
          "FairDrop address not available. Please set it manually later."
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
