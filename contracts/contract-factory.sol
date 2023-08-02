// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./contract.sol";
import "./matching.sol";  // Assuming both contracts are in the same directory

contract ContractFactory {

    MatchingService private matchingServiceInstance;
    address[] public registeredContracts;

    constructor(address _matchingServiceAddress) {
        matchingServiceInstance = MatchingService(_matchingServiceAddress);

        // Set this contract as the factory address in the MatchingService contract
        matchingServiceInstance.setFactoryAddress(address(this));
    }


    mapping(address => Contract[]) public userContracts;
    event ContractCreated(address indexed user, Contract newContract);


    function registerNewContract(address _contractAddress) external {
        // Call the registerContract() function on the MatchingService contract
        matchingServiceInstance.registerContract(_contractAddress);

        // Optionally, store the registered contract's address in this factory for record-keeping
        registeredContracts.push(_contractAddress);
    }


    function createContract(uint256 _amount) public payable {
        require(msg.value == _amount, "Sent value does not match the specified amount.");
        Contract newContract = new Contract{value: _amount}(msg.sender);
        userContracts[msg.sender].push(newContract);

        // Call registerNewContract with the new contract's address
        this.registerNewContract(address(newContract));

        emit ContractCreated(msg.sender, newContract);
    }


    function getContractsByUser(address user) public view returns (Contract[] memory) {
        return userContracts[user];
    }

}