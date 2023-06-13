// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./contract.sol";

contract ContractFactory {
    mapping(address => Contract[]) public userContracts;
    event ContractCreated(address indexed user, Contract newContract);

    function createContract( uint256 _amount) public payable {
        require(msg.value == _amount, "Sent value does not match the specified amount.");
        Contract newContract = new Contract{value: _amount}(msg.sender);
        userContracts[msg.sender].push(newContract);
        emit ContractCreated(msg.sender, newContract);
    }

    function getContractsByUser(address user) public view returns (Contract[] memory) {
        return userContracts[user];
    }
}
