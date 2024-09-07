// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../contracts/FairDrop.sol";

contract Sanity is Script {
  function run() external {
    uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY");
    address deployerAddress = vm.addr(deployerPrivateKey);

    console.log("Deployment Information:");
    console.log("------------------------");
    console.log("Deployer Address:", deployerAddress);

    // Check Optimism
    vm.selectFork(vm.createFork(vm.envString("OPTIMISM_RPC_URL")));
    uint256 optimismBalance = deployerAddress.balance;
    console.log("Optimism Balance:", optimismBalance);

    // Check Arbitrum
    vm.selectFork(vm.createFork(vm.envString("ARBITRUM_RPC_URL")));
    uint256 arbitrumBalance = deployerAddress.balance;
    console.log("Arbitrum Balance:", arbitrumBalance);

    // Display contract information
    console.log("\nContract Information:");
    console.log("------------------------");
    console.log("FairDrop will be deployed on Optimism (Chain ID: 10)");
    console.log(
      "FairDropSatellite will be deployed on Arbitrum (Chain ID: 42161)"
    );

    // Display WorldID and Wormhole information
    console.log("\nExternal Contracts:");
    console.log("------------------------");
    console.log(
      "WorldID (Optimism):", 0x57f928158C3EE7CDad1e4D8642503c4D0201f611
    );
    console.log("Wormhole Relayer:", 0x27428DD2d3DD32A4D7f7C497eAaa23130d894911);

    console.log("\nDeployment Readiness:");
    console.log("------------------------");
    if (optimismBalance > 0 && arbitrumBalance > 0) {
      console.log("Deployer has balance on both chains");
    } else {
      console.log(
        "Warning: Deployer may not have sufficient balance on one or both chains"
      );
    }

    console.log("\nNext Steps:");
    console.log(
      "1. Ensure you have sufficient ETH on both Optimism and Arbitrum for deployment"
    );
    console.log("2. Review the contract parameters and external addresses");
    console.log("3. Run the deployment script when ready");
  }
}
