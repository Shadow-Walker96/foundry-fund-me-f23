// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @dev Remember that any code between vm.startBroadcast(); and vm.stopBroadcast(); will be a transaction
 * and it will cost gas to run it.
 */

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        HelperConfig helperConfig = new HelperConfig();

        // "()" means it is a struct i.e "struct NetworkConfig {...}" but we can remove the bracket
        // bcos we only have 1 variable in our struct also solidity is smart enough to notice that
        // (address ethUsdPriceFeed) = helperConfig.activeNetworkConfig();
        address ethUsdPriceFeed = helperConfig.activeNetworkConfig();

        vm.startBroadcast();
        FundMe fundMe = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}

// To know the storage layout of FundMe contract
// forge inspect FundMe storageLayout
// {
//   "storage": [
//     {
//       "astId": 43617,
//       "contract": "src/FundMe.sol:FundMe",
//       "label": "s_funders",
//       "offset": 0,
//       "slot": "0",
//       "type": "t_array(t_address)dyn_storage"
//     },
//     {
//       "astId": 43621,
//       "contract": "src/FundMe.sol:FundMe",
//       "label": "s_addressToAmountFunded",
//       "offset": 0,
//       "slot": "1",
//       "type": "t_mapping(t_address,t_uint256)"
//     },
//     {
//       "astId": 43624,
//       "contract": "src/FundMe.sol:FundMe",
//       "label": "s_priceFeed",
//       "offset": 0,
//       "slot": "2",
//       "type": "t_contract(AggregatorV3Interface)45"
//     }
//   ],
//   "types": {
//     "t_address": {
//       "encoding": "inplace",
//       "label": "address",
//       "numberOfBytes": "20"
//     },
//     "t_array(t_address)dyn_storage": {
//       "encoding": "dynamic_array",
//       "label": "address[]",
//       "numberOfBytes": "32",
//       "base": "t_address"
//     },
//     "t_contract(AggregatorV3Interface)45": {
//       "encoding": "inplace",
//       "label": "contract AggregatorV3Interface",
//       "numberOfBytes": "20"
//     },
//     "t_mapping(t_address,t_uint256)": {
//       "encoding": "mapping",
//       "key": "t_address",
//       "label": "mapping(address => uint256)",
//       "numberOfBytes": "32",
//       "value": "t_uint256"
//     },
//     "t_uint256": {
//       "encoding": "inplace",
//       "label": "uint256",
//       "numberOfBytes": "32"
//     }
//   }
// }

// forge script script/DeployFundMe.s.sol --rpc-url http://127.0.0.1:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast[⠰] Compiling...
// [⠒] Compiling 4 files with 0.8.19
// [⠊] Compiling 4 files with 0.8.19
// [⠃] Compiling 4 files with 0.8.19
// [⠒] Solc 0.8.19 finished in 10.65s
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

// == Return ==
// 0: contract FundMe 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512

// EIP-3855 is not supported in one or more of the RPCs used.
// Unsupported Chain IDs: 31337.
// Contracts deployed with a Solidity version equal or higher than 0.8.20 might not work properly.
// For more information, please see https://eips.ethereum.org/EIPS/eip-3855

// ## Setting up (1) EVMs.

// ==========================

// Chain 31337

// Estimated gas price: 5 gwei

// Estimated total gas used for script: 1336616

// Estimated amount required: 0.00668308 ETH

// ==========================

// ###
// Finding wallets for all the necessary addresses...
// ##
// Sending transactions [0 - 1].
// ⠉ [00:00:00] [#########################################################################################] 2/2 txes (0.0s)
// Transactions saved to: /home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23/broadcast/DeployFundMe.s.sol/31337/run-latest.json

// Sensitive values saved to: /home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23/cache/DeployFundMe.s.sol/31337/run-latest.json

// ##
// Waiting for receipts.
// ⠙ [00:00:00] [#####################################################################################] 2/2 receipts (0.0s)
// ##### anvil-hardhat
// ✅  [Success]Hash: 0xe0866507c30f41eb84455a587cb18c8697a826a84bc5addda57516d886cbc066
// Contract Address: 0x5FbDB2315678afecb367f032d93F642f64180aa3
// Block: 1
// Paid: 0.001807828 ETH (451957 gas * 4 gwei)

// ##### anvil-hardhat
// ✅  [Success]Hash: 0x3a0689cdbe3d281560deef7f5aa954001a44f86b6d2f943842ac58f2905fa5df
// Contract Address: 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512
// Block: 2
// Paid: 0.002235961384018758 ETH (576462 gas * 3.878766309 gwei)

// Transactions saved to: /home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23/broadcast/DeployFundMe.s.sol/31337/run-latest.json

// Sensitive values saved to: /home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23/cache/DeployFundMe.s.sol/31337/run-latest.json

// ==========================

// ONCHAIN EXECUTION COMPLETE & SUCCESSFUL.
// Total Paid: 0.004043789384018758 ETH (1028419 gas * avg 3.939383154 gwei)

// Transactions saved to: /home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23/broadcast/DeployFundMe.s.sol/31337/run-latest.json

// Sensitive values saved to: /home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23/cache/DeployFundMe.s.sol/31337/run-latest.json

// To display the storage slot of FundMe contract i.e 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 at slot 2
// The "2" is the storage slot we picked to display
// type ---> cast storage 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 2
// 0x0000000000000000000000005fbdb2315678afecb367f032d93f642f64180aa3

// storage slot "0" is empty bcos its an array i.e address[] private s_funders; which is intentionally
// left empty by solidity bcos it dosnt know how large it will become
//  cast storage 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 0
// 0x0000000000000000000000000000000000000000000000000000000000000000

// storage slot "1" is empty bcos its an array too
// i.e mapping(address => uint256) private s_addressToAmountFunded; which is intentionally left empty by solidity
// left empty by solidity bcos it dosnt know how large it will become
// cast storage 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 1
// 0x0000000000000000000000000000000000000000000000000000000000000000

// forge script script/DeployFundMe.s.sol --fork-url $SEPOLIA_RPC_URL
// [⠊] Compiling...
// [⠃] Compiling 1 files with 0.8.19
// [⠒] Solc 0.8.19 finished in 7.86s
// Compiler run successful!
// Script ran successfully.

// == Return ==
// 0: contract FundMe 0x34A1D3fff3958843C43aD80F30b94c510645C316

// ## Setting up (1) EVMs.

// ==========================

// Chain 11155111

// Estimated gas price: 3.000000044 gwei

// Estimated total gas used for script: 749192

// Estimated amount required: 0.002247576032964448 ETH

// ==========================

// SIMULATION COMPLETE. To broadcast these transactions, add --broadcast and wallet configuration(s) to the previous command. See forge script --help for more.

// Transactions saved to: /home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23/broadcast/DeployFundMe.s.sol/11155111/dry-run/run-latest.json

// Sensitive values saved to: /home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23/cache/DeployFundMe.s.sol/11155111/dry-run/run-latest.json

// forge script script/DeployFundMe.s.sol --fork-url $MAINNET_RPC_URL
// [⠰] Compiling...
// No files changed, compilation skipped
// Script ran successfully.

// == Return ==
// 0: contract FundMe 0x90193C961A926261B756D1E5bb255e67ff9498A1

// ## Setting up (1) EVMs.

// ==========================

// Chain 1

// Estimated gas price: 14.879223532 gwei

// Estimated total gas used for script: 1336616

// Estimated amount required: 0.019887808240447712 ETH

// ==========================

// SIMULATION COMPLETE. To broadcast these transactions, add --broadcast and wallet configuration(s) to the previous command. See forge script --help for more.

// Transactions saved to: /home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23/broadcast/DeployFundMe.s.sol/1/dry-run/run-latest.json

// Sensitive values saved to: /home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23/cache/DeployFundMe.s.sol/1/dry-run/run-latest.json

// forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url https://eth-sepolia.g.alchemy.com/v2/0LbxEqeygolntidHOcpI9VbfC7BsDLL2 --private-key 4bdb35f6b9c5a50db14ff00d395aeff95e97e2308e2fc2600cda1f3a6855d8af --broadcast --verify --etherscan-api-key 617W8TATPEAIIVC9UR7VGW778TMQ7T6NC5 -vvvv
// [⠰] Compiling...
// No files changed, compilation skipped
// Traces:
//   [1053750] DeployFundMe::run()
//     ├─ [477067] → new HelperConfig@0xC7f2Cf4845C6db0e1a1e91ED41Bcd0FcC1b0E141
//     │   └─ ← 2161 bytes of code
//     ├─ [381] HelperConfig::activeNetworkConfig() [staticcall]
//     │   └─ ← 0x694AA1769357215DE4FAC081bf1f309aDC325306
//     ├─ [0] VM::startBroadcast()
//     │   └─ ← ()
//     ├─ [486134] → new FundMe@0x26cE589a577F23B37aF5E5EDAB8391C7CB0F29Ac
//     │   └─ ← 2316 bytes of code
//     ├─ [0] VM::stopBroadcast()
//     │   └─ ← ()
//     └─ ← FundMe: [0x26cE589a577F23B37aF5E5EDAB8391C7CB0F29Ac]

// Script ran successfully.

// == Return ==
// 0: contract FundMe 0x26cE589a577F23B37aF5E5EDAB8391C7CB0F29Ac

// ## Setting up (1) EVMs.
// ==========================
// Simulated On-chain Traces:

//   [576302] → new FundMe@0x26cE589a577F23B37aF5E5EDAB8391C7CB0F29Ac
//     └─ ← 2316 bytes of code

// ==========================

// Chain 11155111

// Estimated gas price: 3.000000146 gwei

// Estimated total gas used for script: 749192

// Estimated amount required: 0.002247576109382032 ETH

// ==========================

// ###
// Finding wallets for all the necessary addresses...
// ##
// Sending transactions [0 - 0].
// ⠁ [00:00:00] [#########################################################################################] 1/1 txes (0.0s)
// Transactions saved to: /home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23/broadcast/DeployFundMe.s.sol/11155111/run-latest.json

// Sensitive values saved to: /home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23/cache/DeployFundMe.s.sol/11155111/run-latest.json

// ##
// Waiting for receipts.
// ⠉ [00:00:13] [#####################################################################################] 1/1 receipts (0.0s)
// ##### sepolia
// ✅  [Success]Hash: 0x34cf81e4bbebc2be8820458a95467653b8974723bbcc3bf1b17128fd06409cea
// Contract Address: 0x26cE589a577F23B37aF5E5EDAB8391C7CB0F29Ac
// Block: 4545252
// Paid: 0.001729386038622954 ETH (576462 gas * 3.000000067 gwei)

// Transactions saved to: /home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23/broadcast/DeployFundMe.s.sol/11155111/run-latest.json

// Sensitive values saved to: /home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23/cache/DeployFundMe.s.sol/11155111/run-latest.json

// ==========================

// ONCHAIN EXECUTION COMPLETE & SUCCESSFUL.
// Total Paid: 0.001729386038622954 ETH (576462 gas * avg 3.000000067 gwei)
// ##
// Start verification for (1) contracts
// Start verifying contract `0x26cE589a577F23B37aF5E5EDAB8391C7CB0F29Ac` deployed on sepolia

// Submitting verification for [src/FundMe.sol:FundMe] "0x26cE589a577F23B37aF5E5EDAB8391C7CB0F29Ac".
// Submitted contract for verification:
//         Response: `OK`
//         GUID: `j8vay1ddgfnmt39cazzgqvwvkmltjxevz8wv28gfpr7wy4pwee`
//         URL:
//         https://sepolia.etherscan.io/address/0x26ce589a577f23b37af5e5edab8391c7cb0f29ac
// Contract verification status:
// Response: `NOTOK`
// Details: `Pending in queue`
// Contract verification status:
// Response: `NOTOK`
// Details: `Pending in queue`
// Contract verification status:
// Response: `OK`
// Details: `Pass - Verified`
// Contract successfully verified
// All (1) contracts were verified!

// Transactions saved to: /home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23/broadcast/DeployFundMe.s.sol/11155111/run-latest.json

// Sensitive values saved to: /home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23/cache/DeployFundMe.s.sol/11155111/run-latest.json


// make deploy ARGS="--network sepolia"
// [⠊] Compiling...
// No files changed, compilation skipped
// Traces:
//   [1053750] DeployFundMe::run()
//     ├─ [477067] → new HelperConfig@0xC7f2Cf4845C6db0e1a1e91ED41Bcd0FcC1b0E141
//     │   └─ ← 2161 bytes of code
//     ├─ [381] HelperConfig::activeNetworkConfig() [staticcall]
//     │   └─ ← 0x694AA1769357215DE4FAC081bf1f309aDC325306
//     ├─ [0] VM::startBroadcast()
//     │   └─ ← ()
//     ├─ [486134] → new FundMe@0x005A1BD588bf08054B6226198940237543e4593D
//     │   └─ ← 2316 bytes of code
//     ├─ [0] VM::stopBroadcast()
//     │   └─ ← ()
//     └─ ← FundMe: [0x005A1BD588bf08054B6226198940237543e4593D]


// Script ran successfully.

// == Return ==
// 0: contract FundMe 0x005A1BD588bf08054B6226198940237543e4593D

// ## Setting up (1) EVMs.
// ==========================
// Simulated On-chain Traces:

//   [576302] → new FundMe@0x005A1BD588bf08054B6226198940237543e4593D
//     └─ ← 2316 bytes of code


// ==========================

// Chain 11155111

// Estimated gas price: 3.000000176 gwei

// Estimated total gas used for script: 749192

// Estimated amount required: 0.002247576131857792 ETH

// ==========================

// ###
// Finding wallets for all the necessary addresses...
// ##
// Sending transactions [0 - 0].
// ⠁ [00:00:00] [#########################################################################################] 1/1 txes (0.0s)
// Transactions saved to: /home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23/broadcast/DeployFundMe.s.sol/11155111/run-latest.json

// Sensitive values saved to: /home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23/cache/DeployFundMe.s.sol/11155111/run-latest.json

// ##
// Waiting for receipts.
// ⠉ [00:00:13] [#####################################################################################] 1/1 receipts (0.0s)
// ##### sepolia
// ✅  [Success]Hash: 0xd138f535cf1edc91b3b53073b7f331a50a13b9568cc2a7c3729759cf9d3a26b3
// Contract Address: 0x005A1BD588bf08054B6226198940237543e4593D
// Block: 4545326
// Paid: 0.001729386049575732 ETH (576462 gas * 3.000000086 gwei)


// Transactions saved to: /home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23/broadcast/DeployFundMe.s.sol/11155111/run-latest.json

// Sensitive values saved to: /home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23/cache/DeployFundMe.s.sol/11155111/run-latest.json



// ==========================

// ONCHAIN EXECUTION COMPLETE & SUCCESSFUL.
// Total Paid: 0.001729386049575732 ETH (576462 gas * avg 3.000000086 gwei)
// ##
// Start verification for (1) contracts
// Start verifying contract `0x005A1BD588bf08054B6226198940237543e4593D` deployed on sepolia

// Submitting verification for [src/FundMe.sol:FundMe] "0x005A1BD588bf08054B6226198940237543e4593D".

// Submitting verification for [src/FundMe.sol:FundMe] "0x005A1BD588bf08054B6226198940237543e4593D".
// Submitted contract for verification:
//         Response: `OK`
//         GUID: `pnzcadqwytw3bnasttiuzwe9memu1ein9gbc7bye5sdafyissu`
//         URL:
//         https://sepolia.etherscan.io/address/0x005a1bd588bf08054b6226198940237543e4593d
// Contract verification status:
// Response: `NOTOK`
// Details: `Pending in queue`
// Contract verification status:
// Response: `OK`
// Details: `Pass - Verified`
// Contract successfully verified
// All (1) contracts were verified!

// Transactions saved to: /home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23/broadcast/DeployFundMe.s.sol/11155111/run-latest.json

// Sensitive values saved to: /home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23/cache/DeployFundMe.s.sol/11155111/run-latest.json




