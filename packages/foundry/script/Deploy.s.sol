//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contracts/FairDrop.sol";
import "./DeployHelpers.s.sol";
import { DeployFairDrop } from "./00_deploy_your_contract.s.sol";

contract DeployScript is ScaffoldETHDeploy {
  function run() external {
    DeployFairDrop deployFairDrop = new DeployFairDrop();
    deployFairDrop.run();

    // deploy more contracts here
    // DeployMyContract deployMyContract = new DeployMyContract();
    // deployMyContract.run();
  }
}
