// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Contract {
    address public party1;
    address public party2;
    bool public isActive;
    bool public rideProviderAcceptedStatus;
    bool public rideProviderArrivedAtPickupLocation;
    bool public userReadyToStartRide;
    bool public rideProviderStartedRide;
    bool public rideProviderArrivedAtDropoffLocation;
    bool public userMarkedRideComplete;
    bool public userCanceldRide;
    bool public rideProviderCanceldRide;

    constructor(address _party1) payable {
        party1 = _party1;
        rideProviderAcceptedStatus = false;
        rideProviderArrivedAtPickupLocation = false;
        userReadyToStartRide = false;
        rideProviderStartedRide = false;
        rideProviderArrivedAtDropoffLocation = false;
        userMarkedRideComplete = false;
        userCanceldRide = false;
        rideProviderCanceldRide = false;
    }

    function signContract() public payable {
        require(party2 == address(0), "Party2 has already signed the contract.");
        require(!isActive, "Contract is already active.");
        require(!userCanceldRide, "User cannceld ride ");
        require(msg.sender != party1, "Party2 cannot be identical to Party1.");
        
        party2 = msg.sender;
        isActive = true;

        uint256 tenPercent = (address(this).balance * 10) / 100;
        require(msg.value >= tenPercent, "Party2 must deposit an amount equal to 10% of the contract balance.");

        // Refund any excess amount deposited by party2
        if (msg.value > tenPercent) {
            payable(msg.sender).transfer(msg.value - tenPercent);
        }
    }


    event UpdatePosted(address indexed author, string message, string functionName);


    function setRideProviderAcceptedStatus(string memory _message) public {
        require(isActive, "Contract is not active.");
        require(msg.sender == party2, "Only Party2 can set the ride provider accepted status.");
        require(!rideProviderAcceptedStatus, "Ride Provider Accepted Status can only be set once.");

        require(!rideProviderCanceldRide, "Ride Provider Canceld Ride Status can only be set once.");
        require(!userCanceldRide, "User Canceld Ride Status can only be set once.");

        rideProviderAcceptedStatus = true;
        emit UpdatePosted(msg.sender, _message, "rideProviderAcceptedStatus");
    }

    function setRideProviderArrivedAtPickupLocation(string memory _message) public {
        require(isActive, "Contract is not active.");
        require(msg.sender == party2, "Only Party2 can set the ride provider arrived status.");
        require(rideProviderAcceptedStatus, "Ride Provider Accepted Status must be set before setting arrived status.");
        require(!rideProviderArrivedAtPickupLocation, "Ride Provider Arrived Status can only be set once.");

        require(!rideProviderCanceldRide, "Ride Provider Canceld Ride Status can only be set once.");
        require(!userCanceldRide, "User Canceld Ride Status can only be set once.");
        
        rideProviderArrivedAtPickupLocation = true;
        emit UpdatePosted(msg.sender, _message, "rideProviderArrivedAtPickupLocation");
    }

    function setUserReadyToStartRide(string memory _message) public {
        require(isActive, "Contract is not active.");
        require(msg.sender == party1, "Only Party1 can set the user ready to start ride status.");
        require(rideProviderArrivedAtPickupLocation, "Ride Provider Arrived Status must be set before setting user ready to start ride status.");
        require(!userReadyToStartRide, "User Ready To Start Ride Status can only be set once.");

        require(!rideProviderCanceldRide, "Ride Provider Canceld Ride Status can only be set once.");
        require(!userCanceldRide, "User Canceld Ride Status can only be set once.");

        userReadyToStartRide = true;
        emit UpdatePosted(msg.sender, _message, "userReadyToStartRide");
    }

    function setRideProviderStartedRide(string memory _message) public {
        require(isActive, "Contract is not active.");
        require(msg.sender == party2, "Only Party2 can set the ride provider started ride status.");
        require(userReadyToStartRide, "User Ready To Start Ride Status must be set before setting ride provider started ride status.");
        require(!rideProviderStartedRide, "Ride Provider Started Ride Status can only be set once.");

        require(!rideProviderCanceldRide, "Ride Provider Canceld Ride Status can only be set once.");
        require(!userCanceldRide, "User Canceld Ride Status can only be set once.");

        rideProviderStartedRide = true;
        emit UpdatePosted(msg.sender, _message, "rideProviderStartedRide");
    }

    function setRideProviderArrivedAtDropoffLocation(string memory _message) public {
        require(isActive, "Contract is not active.");
        require(msg.sender == party2, "Only Party2 can set the ride provider arrived at dropoff location status.");
        require(rideProviderStartedRide, "Ride Provider Started Ride Status must be set before setting ride provider arrived at dropoff location status.");
        require(!rideProviderArrivedAtDropoffLocation, "Ride Provider Arrived At Dropoff Location Status can only be set once.");

        require(!rideProviderCanceldRide, "Ride Provider Canceld Ride Status can only be set once.");
        require(!userCanceldRide, "User Canceld Ride Status can only be set once.");

        rideProviderArrivedAtDropoffLocation = true;
        emit UpdatePosted(msg.sender, _message, "rideProviderArrivedAtDropoffLocation");
    }

    function setUserMarkedRideComplete(string memory _message) public {
        require(isActive, "Contract is not active.");
        require(msg.sender == party1, "Only Party1 can set the user marked ride complete status.");
        require(rideProviderArrivedAtDropoffLocation, "Ride Provider Arrived At Dropoff Location Status must be set before setting user marked ride complete status.");
        require(!userMarkedRideComplete, "User Marked Ride Complete Status can only be set once.");

        require(!rideProviderCanceldRide, "Ride Provider Canceld Ride Status can only be set once.");
        require(!userCanceldRide, "User Canceld Ride Status can only be set once.");

        userMarkedRideComplete = true;
        emit UpdatePosted(msg.sender, _message, "userMarkedRideComplete");
    }

    function setUserCanceldRide(string memory _message) public {
        require(msg.sender == party1, "Only Party1 can set the user canceld ride status.");
        
        if(!isActive) {
            uint256 balance = address(this).balance;
            payable(party1).transfer(balance);
            return;
        }

        require(!rideProviderCanceldRide, "Ride Provider Canceld Ride Status can only be set once.");
        require(!userCanceldRide, "User Canceld Ride Status can only be set once.");

        userCanceldRide = true;
        
        if(isActive) {
            uint256 balance = address(this).balance;
            payable(party2).transfer(balance);
        }
        
        emit UpdatePosted(msg.sender, _message, "userCanceldRide");
    }

    function setRideProviderCanceldRide(string memory _message) public {
        require(isActive, "Contract is not active.");
        require(msg.sender == party2, "Only Party2 can set the ride provider canceld ride status.");
        
        require(!rideProviderCanceldRide, "Ride Provider Canceld Ride Status can only be set once.");
        require(!userCanceldRide, "User Canceld Ride Status can only be set once.");

        rideProviderCanceldRide = true;

        uint256 balance = address(this).balance;
        payable(party1).transfer(balance);
        
        emit UpdatePosted(msg.sender, _message, "rideProviderCanceldRide");
    }


    function claimETH(uint256 amount) public {
        require(isActive, "Contract is not active.");
        require(msg.sender == party2, "Only Party2 can claim the deposited ETH.");
        require(userMarkedRideComplete, "User must mark the ride complete before claiming the deposited ETH.");
        require(amount <= address(this).balance, "Requested amount exceeds the contract balance.");
        
        address payable hardcodedAddress = payable(0xE39a3085CB78341547F30a1C6bD12977d51aa967);  // replace with the actual hardcoded address

        uint256 balance = address(this).balance;
        uint256 tenPercent = balance / 10;
        uint256 remainder = balance - tenPercent;

        hardcodedAddress.transfer(tenPercent);

        uint256 payback = remainder - amount;
        remainder -= payback;

        payable(party1).transfer(payback);
        payable(party2).transfer(remainder);
    }


}
