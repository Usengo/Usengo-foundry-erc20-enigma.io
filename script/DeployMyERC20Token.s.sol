// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Import the necessary Foundry libraries
import "forge-std/Script.sol";
import {MyERC20Token} from "../src/MyERC20Token.sol"; // Adjust the import path as needed

contract DeployMyERC20Token is Script {
    address private constant INITIAL_OWNER = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8; // Replace with the actual initial owner address
    uint256 private constant INITIAL_AMOUNT = 1000000 * 10 ** 18; // Example initial amount, adjust as needed

    function run() external {
        // Start recording gas usage
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIVATE_KEY"); // Ensure this private key is set in your environment variables
        vm.startBroadcast(deployerPrivateKey);

        // Deploy the contract
        MyERC20Token token = new MyERC20Token(INITIAL_OWNER, INITIAL_AMOUNT);

        // Stop recording gas usage
        vm.stopBroadcast();

        // Output the deployed contract address
        console.log("MyERC20Token deployed to:", address(token));
    }
}
