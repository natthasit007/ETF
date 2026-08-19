// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract ComplicatedBank {
mapping(address => uint256) balances;
address[] accounts;
address public owner;
uint256 rate = 3;
constructor() {
owner = msg.sender;
}
modifier onlyOwner() {
require(msg.sender == owner, "You are not owner.");
_;
}
function getbalance() public view returns (uint256) {
    return balances[msg.sender];
}
function deposit() public payable {
    if (balances[msg.sender] == 0) {
        accounts.push(msg.sender);
    }
    balances[msg.sender] += msg.value;
}

function withdraw(uint256 moneyWithdraw) public {
    require(balances[msg.sender] >= moneyWithdraw, "Insufficient money to withdraw!!!");

    balances[msg.sender] -= moneyWithdraw;

    (bool success, ) = msg.sender.call{value: moneyWithdraw}("");
    require(success, "Withdraw failed!!");
}

function getSystemBalance() public view onlyOwner returns (uint256) {
    return address(this).balance;
}
function calculateInterest(address _user) public view onlyOwner returns (uint) {
    uint interest = balances[_user] * rate / 100;
    return interest;
}
}