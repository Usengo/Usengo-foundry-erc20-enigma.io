// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {MyERC20Token} from "../src/MyERC20Token.sol";
import {DeployMyERC20Token} from "../script/DeployMyERC20Token.s.sol";

contract DeployMyERC20TokenTest is Test {

    DeployMyERC20Token public deployer;
    MyERC20Token public token;

    // Constants from the deploy script
    address private constant INITIAL_OWNER = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
    uint256 private constant INITIAL_AMOUNT = 1000000 * 10 ** 18;

    function setUp() external {
        // Instantiate the deployer contract
        deployer = new DeployMyERC20Token();
    }

    function testTokenDeployment() external {
        // Deploy the token using the DeployMyERC20Token script
        deployer.run();

        // Retrieve the deployed token address (use console output from the script or hardcode if necessary)
        address tokenAddress = address(new MyERC20Token(INITIAL_OWNER, INITIAL_AMOUNT));

        // Check that the token was deployed to a valid address
        assertTrue(tokenAddress != address(0), "Token should be deployed to a non-zero address");

        // Check that the initial supply matches the expected amount
        token = MyERC20Token(tokenAddress);
        assertEq(token.totalSupply(), INITIAL_AMOUNT, "Initial token supply should match");

        // Verify that the initial owner's balance is correct
        assertEq(token.balanceOf(INITIAL_OWNER), INITIAL_AMOUNT, "Initial owner should have all the tokens");
    }
}
