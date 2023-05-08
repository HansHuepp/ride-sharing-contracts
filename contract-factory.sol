// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./contract.sol";

contract ContractFactory {
    mapping(address => Contract[]) public userContracts;
    event ContractCreated(address indexed user, Contract newContract);

    modifier hasSufficientFunds() {
        require(msg.sender.balance >= 2 ether, "Insufficient funds to deposit 2 ETH.");
        _;
    }

    function createContract(bytes32 _party1Signature) public payable hasSufficientFunds {
        Contract newContract = new Contract{value: 2 ether}(msg.sender, _party1Signature);
        userContracts[msg.sender].push(newContract);
        emit ContractCreated(msg.sender, newContract);
    }

    function getContractsByUser(address user) public view returns (Contract[] memory) {
        return userContracts[user];
    }
}