// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.20; 
 
contract DecentralizedVoting { 
struct Voter { 
bool isRegistered; 
bool hasVoted; 
uint votedProposalId; 
} 
 
 
struct Proposal { 
string name; 
uint voteCount; 
} 
address public admin; 
mapping(address => Voter) public voters; 
Proposal[] public proposals; 
bool public votingStarted; 
bool public votingEnded; 
 
modifier onlyAdmin() { 
require(msg.sender == admin, "Only admin can perform this action"); 
_; 
} 
 
 
modifier onlyDuringVoting() { 
require(votingStarted && !votingEnded, "Voting is not active"); 
_; 
} 
 
 
constructor(string[] memory proposalNames) { 
admin = msg.sender; 
for (uint i = 0; i < proposalNames.length; i++) { 
proposals.push(Proposal({name: proposalNames[i], voteCount: 0})); 
} 
} 
 
 
function registerVoter(address voter) public onlyAdmin { 
require(!voters[voter].isRegistered, "Voter is already registered"); 
voters[voter].isRegistered = true; 
} 
function startVoting() public onlyAdmin { 
require(!votingStarted, "Voting already started"); 
votingStarted = true; 
} 
 
 
function endVoting() public onlyAdmin { 
require(votingStarted && !votingEnded, "Voting not active or already ended"); 
votingEnded = true; 
} 
 
 
function vote(uint proposalId) public onlyDuringVoting { 
Voter storage sender = voters[msg.sender]; 
require(sender.isRegistered, "You are not registered to vote"); 
require(!sender.hasVoted, "You have already voted"); 
require(proposalId < proposals.length, "Invalid proposal"); 
 
sender.hasVoted = true; 
sender.votedProposalId = proposalId; 
proposals[proposalId].voteCount += 1; 
} 
 
 
function getWinningProposal() public view returns (uint winningProposalId) { 
require(votingEnded, "Voting not ended yet"); 
uint maxVotes = 0; 
for (uint i = 0; i < proposals.length; i++) { 
if (proposals[i].voteCount > maxVotes) { 
maxVotes = proposals[i].voteCount; 
winningProposalId = i; 
} 
} 
} 
 
 
function getProposalList() public view returns (Proposal[] memory) { 
return proposals; 
} 
 
 
function getMyVote() public view returns (uint) { 
require(voters[msg.sender].hasVoted, "You haven't voted yet"); 
return voters[msg.sender].votedProposalId; 
} 
}