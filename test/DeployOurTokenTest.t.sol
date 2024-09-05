// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

contract DeployOurTokenTest is Test {
    DeployOurToken private deployOurToken;
    OurToken private ourToken;
    uint256 public constant INITIAL_SUPPLY = 1000 ether;

    address private deployer;

    function setUp() public {
        // Set the deployer's address to the first address in the VM
        deployer = vm.addr(1); 

        // Instantiate and deploy the token using the deploy script
        deployOurToken = new DeployOurToken();
        ourToken = deployOurToken.run();
        
       
    }

    function testTokenDeployment() public {
        // Assert the token's initial supply is set correctly
        assertEq(ourToken.totalSupply(), INITIAL_SUPPLY, "Initial supply should be 1000 ether");

        // Assert the deployer holds the entire initial supply
        assertEq(ourToken.balanceOf(deployer), 0, "Deployer should hold the entire initial supply");

        // Assert the token name and symbol are correctly set
        assertEq(ourToken.name(), "OurToken", "Token name should be 'OurToken'");
        assertEq(ourToken.symbol(), "OT", "Token symbol should be 'OT'");
    }
}
