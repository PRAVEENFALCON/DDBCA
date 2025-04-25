// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DAOWithPool {

    address public manager;
    uint public proposalCount;

    struct Proposal {
        uint id;
        string description;
        uint amount;
        address payable recipient;
        uint votes;
        uint endTime;
        bool executed;
        mapping(address => bool) voters;
    }

    mapping(uint => Proposal) public proposals;
    mapping(address => uint) public shares;
    uint public totalShares;

    constructor() {
        manager = msg.sender;
    }

    modifier onlyMember() {
        require(shares[msg.sender] > 0, "Not a DAO member");
        _;
    }

    function contribute() public payable {
        require(msg.value > 0, "Must send ETH");
        shares[msg.sender] += msg.value;
        totalShares += msg.value;
    }

    function createProposal(string memory _desc, uint _amount, address payable _recipient) public onlyMember {
        require(_amount <= address(this).balance, "Insufficient funds");
        proposalCount++;
        Proposal storage p = proposals[proposalCount];
        p.id = proposalCount;
        p.description = _desc;
        p.amount = _amount;
        p.recipient = _recipient;
        p.endTime = block.timestamp + 180; // 180 seconds
    }

    function vote(uint _proposalId) public onlyMember {
        Proposal storage p = proposals[_proposalId];
        require(block.timestamp < p.endTime, "Voting period over");
        require(!p.voters[msg.sender], "Already voted");

        p.voters[msg.sender] = true;
        p.votes += shares[msg.sender];
    }

    function executeProposal(uint _proposalId) public onlyMember {
        Proposal storage p = proposals[_proposalId];
        require(block.timestamp >= p.endTime, "Voting not ended");
        require(!p.executed, "Already executed");
        require(p.votes > totalShares / 2, "Not enough votes");

        p.executed = true;
        p.recipient.transfer(p.amount);
    }

    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }
}
