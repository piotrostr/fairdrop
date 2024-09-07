//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contracts/FairDrop.sol";
import "./DeployHelpers.s.sol";

contract DeployFairDrop is ScaffoldETHDeploy {
  // use `deployer` from `ScaffoldETHDeploy`
  function run() external ScaffoldEthDeployerRunner {
    // WORLD_ID ENS optimism.id.worldcoin.eth
    console.log("deployer: ", msg.sender);
    address worldId = 0x57f928158C3EE7CDad1e4D8642503c4D0201f611;
    string memory appId = "app_9f3c3c467dbfb7c616671b1b07c3f221";
    string memory actionId = "verify";
    FairDrop fairDrop = new FairDrop(IWorldID(worldId), appId, actionId);
    console.logString(
      string.concat("FairDrop deployed at: ", vm.toString(address(fairDrop)))
    );
  }
}
