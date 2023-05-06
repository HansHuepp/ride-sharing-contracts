pragma solidity ^0.8.0;

contract Contract {
    address public party1;
    address public party2;
    bytes32 public party1Signature;
    bytes32 public party2Signature;
    bool public isActive;

    constructor(address _party1, bytes32 _party1Signature) {
        party1 = _party1;
        party1Signature = _party1Signature;
    }

    function signContract(bytes32 _party2Signature) public {
        require(party2 == address(0), "Party2 has already signed the contract.");
        require(!isActive, "Contract is already active.");
        require(msg.sender != party1, "Party2 cannot be identical to Party1.");

        party2 = msg.sender;
        party2Signature = _party2Signature;
        isActive = true;
    }

    event UpdatePosted(address indexed author, string message);

    function postUpdate(string memory _message) public {
        require(isActive, "Contract is not active.");
        require(msg.sender == party1 || msg.sender == party2, "Not a party to the contract.");

        emit UpdatePosted(msg.sender, _message);
    }
}
