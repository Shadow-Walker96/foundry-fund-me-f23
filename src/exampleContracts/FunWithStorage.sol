// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract FunWithStorage {
    uint256 favoriteNumber; // Stored at slot 0
    bool someBool; // Stored at slot 1
    uint256[] myArray; /* Array Length Stored at slot 2,
        but the objects will be the keccak256(2), since 2 is the storage slot of the array */
    mapping(uint256 => bool) myMap; /* An empty slot is held at slot 3
        and the elements will be stored at keccak256(h(k) . p)
        p: The storage slot (aka, 3)
        k: The key in hex
        h: Some function based on the type. For uint256, it just pads the hex
        */
    uint256 constant NOT_IN_STORAGE = 123;
    uint256 immutable i_not_in_storage;

    constructor() {
        favoriteNumber = 25; // See stored spot above // SSTORE
        someBool = true; // See stored spot above // SSTORE
        myArray.push(222); // SSTORE
        myMap[0] = true; // SSTORE
        i_not_in_storage = 123;
    }

    function doStuff() public {
        uint256 newVar = favoriteNumber + 1; // SLOAD
        bool otherVar = someBool; // SLOAD
            // ^^ memory variables
    }
}

// forge build
// [⠘] Compiling...
// [⠒] Compiling 28 files with 0.8.19
// [⠊] Solc 0.8.19 finished in 43.26s
// Compiler run successful with warnings:
// Warning (2072): Unused local variable.
//   --> src/exampleContracts/FunWithStorage.sol:27:9:
//    |
// 27 |         uint256 newVar = favoriteNumber + 1; // SLOAD
//    |         ^^^^^^^^^^^^^^

// Warning (2072): Unused local variable.
//   --> src/exampleContracts/FunWithStorage.sol:28:9:
//    |
// 28 |         bool otherVar = someBool; // SLOAD
//    |         ^^^^^^^^^^^^^

// Warning (2018): Function state mutability can be restricted to view
//   --> src/exampleContracts/FunWithStorage.sol:26:5:
//    |
// 26 |     function doStuff() public {
//    |     ^ (Relevant source part starts here and spans across multiple lines).

// forge create FunWithStorage --interactive
// [⠆] Compiling...
// No files changed, compilation skipped
// Enter private key: 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
// Deployer: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
// Deployed to: 0x5FbDB2315678afecb367f032d93F642f64180aa3
// Transaction hash: 0x75afa5ff5d8d034ce065d682b1880ea9ab98a6ca54c560dd77d0410d914749ae
