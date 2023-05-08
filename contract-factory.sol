pragma solidity ^0.8.0;

import "./contract.sol";

contract ContractFactory {
    mapping(address => Contract[]) public userContracts;
    event ContractCreated(address indexed user, Contract newContract);

    function createContract(bytes32 _party1Signature) public {
        Contract newContract = new Contract(msg.sender, _party1Signature);
        userContracts[msg.sender].push(newContract);
        emit ContractCreated(msg.sender, newContract);
    }

    function getContractsByUser(address user) public view returns (Contract[] memory) {
        return userContracts[user];
    }
}
