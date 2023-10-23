// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @notice foundry-devops is a repo to get the most recent deployment from a given environment in foundry.
 * it will look through your broadcast folder at your most recent deployment.
 * @dev we purposely seperated fundFundMe() and run() bcos we would write integration test for fundFundMe()
 */

import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether;

    function fundFundMe(address mostRecentDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentDeployed)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("Funded FundMe with %s", SEND_VALUE);
    }

    /**
     * @dev How it works is that it checks the broadcast folder based on the chainid and it check
     * the run-latest.json file and pick the recent FundMe contract address
     */
    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        fundFundMe(mostRecentDeployed);
    }
}

contract WithdrawFundMe is Script {
    function withdrawFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).withdraw();
        vm.stopBroadcast();
        console.log("Withdraw FundMe balance!");
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        withdrawFundMe(mostRecentlyDeployed);
    }
}

// forge script script/Interactions.s.sol:FundFundMe --rpc-url http://127.0.0.1:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast
// [⠔] Compiling...
// [⠑] Compiling 1 files with 0.8.19
// [⠘] Solc 0.8.19 finished in 10.16s
// Compiler run successful!
// 2023-10-23T05:49:26.652304Z ERROR apply:ext: evm::cheatcodes: non-empty stderr args=["bash", "/home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23/lib/foundry-devops/src/get_recent_deployment.sh", "FundMe", "31337", "/home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23//broadcast"] stderr="/home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23/lib/foundry-devops/src/get_recent_deployment.sh: line 31: jq: command not found\n/home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23/lib/foundry-devops/src/get_recent_deployment.sh: line 33: jq: command not found\n/home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23/lib/foundry-devops/src/get_recent_deployment.sh: line 35: ((: i<: syntax error: operand expected (error token is \"<\")\n"
// Traces:
//   [639098] → new DevOpsTools@0x5FbDB2315678afecb367f032d93F642f64180aa3
//     └─ ← 3192 bytes of code

//   [226569] → new FundFundMe@0x5b73C5498c1E3b4dbA84de0F1833c4a029d90519
//     └─ ← 1021 bytes of code

//   [59781] FundFundMe::run()
//     ├─ [35769] DevOpsTools::e374cdf1(00000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000007a69000000000000000000000000000000000000000000000000000000000000000646756e644d650000000000000000000000000000000000000000000000000000) [delegatecall]
//     │   ├─ [0] VM::ffi([pwd])
//     │   │   └─ ← 0x2f686f6d652f736861646f772d77616c6b65722f666f756e6472792d66756c6c2d636f757273652d6632332f666f756e6472792d66756e642d6d652d663233
//     │   ├─ [0] VM::toString(31337 [3.133e4]) [staticcall]
//     │   │   └─ ← 0x000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000053331333337000000000000000000000000000000000000000000000000000000
//     │   ├─ [0] VM::ffi([bash, /home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23/lib/foundry-devops/src/get_recent_deployment.sh, FundMe, 31337, /home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23//broadcast])
//     │   │   └─ ← 0x0000000000000000000000000000000000000000
//     │   ├─ [0] console::log(Return Data:) [staticcall]
//     │   │   └─ ← ()
//     │   ├─ [0] console::log(0x0000000000000000000000000000000000000000) [staticcall]
//     │   │   └─ ← ()
//     │   └─ ← 0x08c379a0000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000144e6f20636f6e7472616374206465706c6f796564000000000000000000000000
//     └─ ← "No contract deployed"

// == Logs ==
//   Return Data:
//   0x0000000000000000000000000000000000000000
// Error:
// No contract deployed

// forge script script/Interactions.s.sol:WithdrawFundMe --rpc-url http://127.0.0.1:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast
// [⠆] Compiling...
// No files changed, compilation skipped
// 2023-10-23T05:55:56.607457Z ERROR apply:ext: evm::cheatcodes: non-empty stderr args=["bash", "/home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23/lib/foundry-devops/src/get_recent_deployment.sh", "FundMe", "31337", "/home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23//broadcast"] stderr="/home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23/lib/foundry-devops/src/get_recent_deployment.sh: line 31: jq: command not found\n/home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23/lib/foundry-devops/src/get_recent_deployment.sh: line 33: jq: command not found\n/home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23/lib/foundry-devops/src/get_recent_deployment.sh: line 35: ((: i<: syntax error: operand expected (error token is \"<\")\n"
// Traces:
//   [639098] → new DevOpsTools@0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0
//     └─ ← 3192 bytes of code

//   [220362] → new WithdrawFundMe@0x5b73C5498c1E3b4dbA84de0F1833c4a029d90519
//     └─ ← 990 bytes of code

//   [59759] WithdrawFundMe::run()
//     ├─ [35769] DevOpsTools::e374cdf1(00000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000007a69000000000000000000000000000000000000000000000000000000000000000646756e644d650000000000000000000000000000000000000000000000000000) [delegatecall]
//     │   ├─ [0] VM::ffi([pwd])
//     │   │   └─ ← 0x2f686f6d652f736861646f772d77616c6b65722f666f756e6472792d66756c6c2d636f757273652d6632332f666f756e6472792d66756e642d6d652d663233
//     │   ├─ [0] VM::toString(31337 [3.133e4]) [staticcall]
//     │   │   └─ ← 0x000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000053331333337000000000000000000000000000000000000000000000000000000
//     │   ├─ [0] VM::ffi([bash, /home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23/lib/foundry-devops/src/get_recent_deployment.sh, FundMe, 31337, /home/shadow-walker/foundry-full-course-f23/foundry-fund-me-f23//broadcast])
//     │   │   └─ ← 0x0000000000000000000000000000000000000000
//     │   ├─ [0] console::log(Return Data:) [staticcall]
//     │   │   └─ ← ()
//     │   ├─ [0] console::log(0x0000000000000000000000000000000000000000) [staticcall]
//     │   │   └─ ← ()
//     │   └─ ← 0x08c379a0000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000144e6f20636f6e7472616374206465706c6f796564000000000000000000000000
//     └─ ← "No contract deployed"

// == Logs ==
//   Return Data:
//   0x0000000000000000000000000000000000000000
// Error:
// No contract deployed
