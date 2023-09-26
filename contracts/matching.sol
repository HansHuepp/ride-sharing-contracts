// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MatchingService {

    struct MatchingServiceObject {
        string name;
        uint256 matches;
        uint256 requests;
    }


    MatchingServiceObject[5] public services;

    address public FACTORY_ADDRESS;
    bool public isFactoryAddressSet = false;

    mapping(address => bool) public registeredContracts;
    address[] public registeredContractsList; 

    // Declare the event
    event LowestMatchService(string serviceName, uint256 serviceRating);

    modifier onlyFactory() {
        require(msg.sender == FACTORY_ADDRESS, "Only the factory can call this");
        _;
    }

    modifier onlyRegisteredContracts() {
        require(registeredContracts[msg.sender], "Only registered contracts can call this");
        _;
    }

    //Hardcoded Dummy Matching Services 
    constructor() {
        services[0] = MatchingServiceObject("ms1", 10, 15);
        services[1] = MatchingServiceObject("ms2", 15, 20);
        services[2] = MatchingServiceObject("ms3", 20, 30);
        services[3] = MatchingServiceObject("ms4", 5, 10);
        services[4] = MatchingServiceObject("ms5", 8, 12);
    }

    function setFactoryAddress(address _factoryAddress) external {
        require(!isFactoryAddressSet, "Factory address is already set");
        FACTORY_ADDRESS = _factoryAddress;
        isFactoryAddressSet = true;
    }

    function registerContract(address contractAddress) external onlyFactory {
        require(!registeredContracts[contractAddress], "Contract is already registered"); // Additional check to prevent duplicate addresses
        registeredContracts[contractAddress] = true;
        registeredContractsList.push(contractAddress); 
    }

    function getAllRegisteredContracts() external view returns (address[] memory) {
        return registeredContractsList;
    }

    function getMatchingService(string[] memory names) public {
        uint256 lowestMatches = type(uint256).max;

        string memory lowestMatchServiceName = "";
        uint256 lowestMatchServiceRating;

        for (uint i = 0; i < names.length; i++) {
            for (uint j = 0; j < services.length; j++) {
                if (keccak256(bytes(services[j].name)) == keccak256(bytes(names[i]))) {
                    if (services[j].matches < lowestMatches) {
                        lowestMatches = services[j].matches;
                        lowestMatchServiceName = services[j].name;
                        lowestMatchServiceRating = (services[j].matches * 100) / services[j].requests; // Multiply by 100 for two decimal places
                        services[j].requests += 1;
                    }
                }
            }
        }
        // Emit the event with the result
        emit LowestMatchService(lowestMatchServiceName, lowestMatchServiceRating);
    }

    function addMatch(string memory serviceName) external onlyRegisteredContracts {
        for (uint i = 0; i < services.length; i++) {
            if (keccak256(bytes(services[i].name)) == keccak256(bytes(serviceName))) {
                services[i].matches += 1;
            }
        }
    }
}