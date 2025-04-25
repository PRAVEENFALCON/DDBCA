// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery {

    address[] private players;
    address public lotteryWinner;

    constructor() payable {}

    function enter() public payable {
        require(msg.value > 0, "Must send ETH to enter");
        players.push(msg.sender);
    }

    function getPlayers() public view returns (address[] memory) {
        return players;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function pickWinner() public {
        require(players.length > 2, "Not enough players entered");

        uint index = random() % players.length;
        address winner = players[index];

        lotteryWinner = winner;
        payable(winner).transfer(address(this).balance);

        delete players;
    }

    function random() private view returns (uint256) {
        return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, players.length)));
    }
}
