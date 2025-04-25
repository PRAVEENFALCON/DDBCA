// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Insurance {
    address public insurer;
    uint public constant premium = 1 ether;
    uint public constant payout = 2 ether;

    mapping(address => bool) public insured;
    mapping(address => bool) public hasClaimed;

    constructor() {
        insurer = msg.sender;
    }

    modifier onlyInsurer() {
        require(msg.sender == insurer, "Only insurer can call this.");
        _;
    }

    modifier isInsured(address _user) {
        require(insured[_user], "User is not insured.");
        _;
    }

    function buyInsurance() public payable {
        require(msg.value == premium, "Incorrect premium amount.");
        require(!insured[msg.sender], "Already insured.");
        insured[msg.sender] = true;
    }

    function confirmEventAndPay(address _user) public onlyInsurer isInsured(_user) {
        require(!hasClaimed[_user], "Already claimed.");
        require(address(this).balance >= payout, "Insufficient contract balance.");

        hasClaimed[_user] = true;
        payable(_user).transfer(payout);
    }

    function fundContract() public payable onlyInsurer {}

    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }
}
