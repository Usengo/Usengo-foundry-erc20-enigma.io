// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {OurToken} from "../src/OurToken.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DeployOurToken is Script {
    uint256 public constant INITIAL_SUPPLy = 1000 ether;
    
    function run() external returns (OurToken) {
        vm.startBroadcast(msg.sender);
         OurToken ourToken = new OurToken(INITIAL_SUPPLy);
        vm.stopBroadcast();
       return ourToken;
    }

    
}
