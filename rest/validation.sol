// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SignatureVerifier {
    function verify(string memory message, bytes32 _data, uint8 _v, bytes32 _r, bytes32 _s) public pure returns (bool) {
        bytes32 messageHash = keccak256(abi.encodePacked(message));

        // Check if the provided hash matches the hash of the provided message
        if (messageHash != _data) {
            return false;
        }

        bytes memory prefix = "\x19Ethereum Signed Message:\n32";
        bytes32 hash = keccak256(abi.encodePacked(prefix, _data));
        address signer = ecrecover(hash, _v, _r, _s);
        
        address hardcodedSigner = 0x312e3fCC55779085be69330095dd9A9a50EB183f; 

        return (signer == hardcodedSigner);
    }
}
