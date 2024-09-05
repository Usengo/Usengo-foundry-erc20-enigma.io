// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

// Importing Ownable contract from OpenZeppelin
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract MyERC20Token is Ownable {
    
    // Custom errors for transfer failures and insufficient funds
    error MyERC20Token__transferFailed();
    error MyERC20Token__notEnoughFund();
    error MyERC20Token__AllowanceExceeded();

    // Private variables to store total supply and balances
    uint256 private immutable AMOUNT; 
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    // Event to emit when tokens are transferred
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed from, address indexed to, uint256 value);

    // Constructor to initialize the owner of the contract and set the initial supply
    constructor(address initialOwner, uint256 initialAmount) Ownable(msg.sender) {
        transferOwnership(initialOwner); // Set the initial owner
        _totalSupply = initialAmount;    // Set the initial total supply
        _balances[initialOwner] = initialAmount; // Assign all tokens to the owner
        AMOUNT = initialAmount;          // Set the immutable amount variable
    }

    // Function to return the total supply of the token
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    // Function to return the balance of a specific account
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    // Function to transfer tokens from the caller to a recipient
    function transfer(address recipient, uint256 amount) public returns (bool) {
        address sender = msg.sender;

        // Check if the sender has enough balance
        if (_balances[sender] < amount) {
            revert MyERC20Token__notEnoughFund();
        }

        // Adjust sender and recipient balances
        _balances[sender] -= amount;
        _balances[recipient] += amount;

        // Emit the Transfer event
        emit Transfer(sender, recipient, amount);

        return true;
    }
     
     
    function approve(address spender, uint256 amount) public returns (bool) {
        // Allow `spender` to spend up to `amount` on behalf of the caller (msg.sender)
        _allowances[msg.sender][spender] = amount;

        // Emit the Approval event as per ERC20 standards
        emit Approval(msg.sender, spender, amount);

        return true;
    }
    function allowance(address owner, address spender) public view returns (uint256) {
    return _allowances[owner][spender];
}
    // Function to allow transferring tokens on behalf of someone else
    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {

        // Check if the sender has enough balance
        if (_balances[sender] < amount) {
            revert MyERC20Token__notEnoughFund();
        }

        // Check if the caller is allowed to transfer this amount
        if (_allowances[sender][msg.sender] < amount) {
            revert MyERC20Token__AllowanceExceeded();
        }
        
        // Adjust allowances and balances
        _allowances[sender][msg.sender] -= amount;
        _balances[sender] -= amount;
        _balances[recipient] += amount;

        // Emit the Transfer event
        emit Transfer(sender, recipient, amount);

        return true;
    }

}
