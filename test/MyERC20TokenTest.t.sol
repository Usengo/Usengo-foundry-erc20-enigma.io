// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {MyERC20Token} from "../src/MyERC20Token.sol";
import {DeployMyERC20Token} from "../script/DeployMyERC20Token.s.sol";

contract MyERC20TokenTest is Test {
    // Address and amount constants
    address private constant INITIAL_OWNER = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
    uint256 private constant INITIAL_AMOUNT = 1000000 * 10 ** 18;
    address private constant RECIPIENT = 0x9fC7A419532a2Fc6DAD70aaC7e96e9879211f4a4;
        event Approval(address indexed from, address indexed to, uint256 value);

    // Token and deployer contract instances
    MyERC20Token public token;
    DeployMyERC20Token public deployer;

    function setUp() external {
        // Instantiate and deploy the token using DeployMyERC20Token
        deployer = new DeployMyERC20Token();

        // Set the initial owner and amount for the token contract
        vm.startBroadcast();
        token = new MyERC20Token(INITIAL_OWNER, INITIAL_AMOUNT); // Deploy the token manually
        vm.stopBroadcast();
    }

    // Example test function to verify initial supply
    function testInitialSupply() external view {
        uint256 expectedSupply = INITIAL_AMOUNT;
        assertEq(token.totalSupply(), expectedSupply, "Initial supply should match");
    }

    function testBalanceOf() external view{
        // Test if the initial owner has the correct balance after deployment
        uint256 ownerBalance = token.balanceOf(INITIAL_OWNER);

        // Assert that the balance of the initial owner is equal to the initial amount
        assertEq(ownerBalance, INITIAL_AMOUNT, "Owner should have the initial token supply");
    }

    function testTransfer() external {
        uint256 transferAmount = 1000;

        // Prank the initial owner to simulate a transfer from their account
        vm.prank(INITIAL_OWNER);
        token.transfer(RECIPIENT, transferAmount);

        // Assert that the transfer succeeded by checking balances
        assertEq(token.balanceOf(RECIPIENT), transferAmount);
        //  vm.expectRevert(MyERC20Token.MyERC20Token__notEnoughFund.selector);
    }

    function testTransferFrom() external {
        uint256 transferAmount = 500 * 10 ** 18;
        uint256 initialAmount = 1000 * 10 ** 18;

        // Approve the spender to spend on behalf of the sender
        vm.prank(INITIAL_OWNER);
        token.approve(address(this), transferAmount);

        // Call transferFrom to transfer tokens from the sender to the recipient
        vm.prank(address(this));
        bool success = token.transferFrom(INITIAL_OWNER, RECIPIENT, transferAmount);

        // Assert the transfer was successful
        assertTrue(success, "Transfer should succeed");

        // Validate that balances and allowance have updated correctly
        assertEq(token.balanceOf(RECIPIENT), transferAmount, "Recipient should receive tokens");
        assertEq(token.balanceOf(INITIAL_OWNER), INITIAL_AMOUNT - transferAmount, "Sender's balance should decrease by the transfer amount");

        // Validate that the allowance has been reduced
        assertEq(token.allowance(INITIAL_OWNER, address(this)), 0, "Allowance should be reduced to 0 after transfer");
    }

    function testApprove() public {
        uint256 amountToApprove = 500 * 10 ** 18;

        // Prank to simulate approval coming from the owner
        vm.prank(INITIAL_OWNER);
        bool success = token.approve(RECIPIENT, amountToApprove);

        // Assert that approve returns true
        assertTrue(success, "Approve should return true");

        // Check that the allowance was set correctly
        uint256 allowance = token.allowance(INITIAL_OWNER, RECIPIENT);
        assertEq(allowance, amountToApprove, "Allowance should be set correctly");

        // Validate that the Approval event was emitted
        vm.expectEmit(true, true, false, true);
        emit Approval(INITIAL_OWNER, RECIPIENT, amountToApprove);

        // Simulate approval again for event check
        vm.prank(INITIAL_OWNER);
        token.approve(RECIPIENT, amountToApprove);
    }
}
