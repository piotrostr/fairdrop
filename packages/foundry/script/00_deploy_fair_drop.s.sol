//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contracts/FairDrop.sol";
import "./DeployHelpers.s.sol";

contract DeployFairDrop is ScaffoldETHDeploy {
  function run() external ScaffoldEthDeployerRunner {
    console.log("deployer: ", msg.sender);
    require(block.chainid == 10, "Must be deployed on Optimism");

    // WorldID address on Optimism
    address worldId = 0x57f928158C3EE7CDad1e4D8642503c4D0201f611;
    string memory appId = "app_9f3c3c467dbfb7c616671b1b07c3f221";
    string memory actionId = "verify";

    // Wormhole Relayer address on Optimism (same for all EVM chains)
    address wormholeRelayer = 0x27428DD2d3DD32A4D7f7C497eAaa23130d894911;

    // Optimism chain ID
    uint16 chainId = 10;

    FairDrop fairDrop =
      new FairDrop(worldId, appId, actionId, wormholeRelayer, chainId);

    console.logString(
      string.concat("FairDrop deployed at: ", vm.toString(address(fairDrop)))
    );

    // Add deployment to the list
    deployments.push(Deployment("FairDrop", address(fairDrop)));
  }
}
