// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {FunWithStorage} from "../src/exampleContracts/FunWithStorage.sol";

contract DeployFunWithStorage is Script {
    function run() external returns (FunWithStorage) {
        vm.startBroadcast();
        FunWithStorage funWithStorage = new FunWithStorage();
        vm.stopBroadcast();
        printStorageData(address(funWithStorage));
        printFirstArrayElement(address(funWithStorage));
        return (funWithStorage);
    }

    function printStorageData(address contractAddress) public view {
        for (uint256 i = 0; i < 10; i++) {
            bytes32 value = vm.load(contractAddress, bytes32(i));
            console.log("Vaule at location", i, ":");
            console.logBytes32(value);
        }
    }

    function printFirstArrayElement(address contractAddress) public view {
        bytes32 arrayStorageSlotLength = bytes32(uint256(2));
        bytes32 firstElementStorageSlot = keccak256(abi.encode(arrayStorageSlotLength));
        bytes32 value = vm.load(contractAddress, firstElementStorageSlot);
        console.log("First element in array:");
        console.logBytes32(value);
    }

    // Option 1
    /*
     * cast storage ADDRESS
     */

    // Option 2
    // cast k 0x0000000000000000000000000000000000000000000000000000000000000002
    // cast storage ADDRESS <OUTPUT_OF_ABOVE>

    // Option 3:
    /*
     * curl -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"debug_traceTransaction","params":["0xe98bc0fd715a075b83acbbfd72b4df8bb62633daf1768e9823896bfae4758906"],"id":1}' http://127.0.0.1:8545 > debug_tx.json
     * Go through the JSON and find the storage slot you want
     */

    // You could also replay every transaction and track the `SSTORE` opcodes... but that's a lot of work
}

// forge script script/DeployStorageFun.s.sol
// [⠊] Compiling...
// [⠘] Compiling 2 files with 0.8.19
// [⠃] Solc 0.8.19 finished in 4.70s
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

// Script ran successfully.
// Gas used: 222686

// == Return ==
// 0: contract FunWithStorage 0x90193C961A926261B756D1E5bb255e67ff9498A1

// == Logs ==
//   Vaule at location 0 :
//   0x0000000000000000000000000000000000000000000000000000000000000019
//   Vaule at location 1 :
//   0x0000000000000000000000000000000000000000000000000000000000000001
//   Vaule at location 2 :
//   0x0000000000000000000000000000000000000000000000000000000000000001
//   Vaule at location 3 :
//   0x0000000000000000000000000000000000000000000000000000000000000000
//   Vaule at location 4 :
//   0x0000000000000000000000000000000000000000000000000000000000000000
//   Vaule at location 5 :
//   0x0000000000000000000000000000000000000000000000000000000000000000
//   Vaule at location 6 :
//   0x0000000000000000000000000000000000000000000000000000000000000000
//   Vaule at location 7 :
//   0x0000000000000000000000000000000000000000000000000000000000000000
//   Vaule at location 8 :
//   0x0000000000000000000000000000000000000000000000000000000000000000
//   Vaule at location 9 :
//   0x0000000000000000000000000000000000000000000000000000000000000000
//   First element in array:
//   0x00000000000000000000000000000000000000000000000000000000000000de

// If you wish to simulate on-chain transactions pass a RPC URL.
