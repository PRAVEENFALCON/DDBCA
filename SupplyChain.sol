// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract UltraSimpleSupplyChainV2 {

    uint256 private nextGoodId = 1;
    mapping(uint256 => string) public goodNames;
    mapping(uint256 => address) public goodOwners;

    event GoodCreated(uint256 indexed goodId, string name, address indexed initialOwner);
    event GoodTransferred(uint256 indexed goodId, address indexed from, address indexed to);

    modifier goodExists(uint256 _goodId) {
        require(goodOwners[_goodId] != address(0), "Good does not exist");
        _;
    }

    modifier onlyGoodOwner(uint256 _goodId) {
        require(goodOwners[_goodId] == msg.sender, "Caller is not the current owner");
        _;
    }

    function addGood(string memory _name) public returns (uint256) {
        uint256 goodId = nextGoodId;
        goodNames[goodId] = _name;
        goodOwners[goodId] = msg.sender;
        nextGoodId++;
        emit GoodCreated(goodId, _name, msg.sender);
        return goodId;
    }

    function transferGood(uint256 _goodId, address _newOwner) public goodExists(_goodId) onlyGoodOwner(_goodId) {
        require(_newOwner != address(0), "New owner cannot be the zero address");
        address previousOwner = goodOwners[_goodId];
        goodOwners[_goodId] = _newOwner;
        emit GoodTransferred(_goodId, previousOwner, _newOwner);
    }

    function getGoodDetails(uint256 _goodId) public view goodExists(_goodId) returns (uint256 id, string memory name, address currentOwner) {
        return (_goodId, goodNames[_goodId], goodOwners[_goodId]);
    }
}
