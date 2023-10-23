// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @dev Here we want to write integration test for FundFundMe() from Interactions.s.sol
 */

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract IntegrationsTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether; // 100000000000000000
    uint256 constant STARTING_USER_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_USER_BALANCE); // We give 10 ether to the user
    }

    function testUserCanFundInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assert(address(fundMe).balance == 0);
    }
}

// forge test --mt testUserCanFundInteractions
// [⠘] Compiling...
// [⠒] Compiling 1 files with 0.8.19
// [⠢] Solc 0.8.19 finished in 8.24s
// Compiler run successful!

// Running 1 test for test/Integration/InteractionsTest.t.sol:IntegrationsTest
// [PASS] testUserCanFundInteractions() (gas: 563232)
// Test result: ok. 1 passed; 0 failed; 0 skipped; finished in 5.07ms

// Ran 1 test suites: 1 tests passed, 0 failed, 0 skipped (1 total tests)

// forge test
// [⠢] Compiling...
// [⠒] Compiling 1 files with 0.8.19
// [⠆] Solc 0.8.19 finished in 11.92s
// Compiler run successful!

// Running 10 tests for test/unit/FundMeTest.t.sol:FundMeTest
// [PASS] testAddsFunderToArrayOfFunders() (gas: 99704)
// [PASS] testFundFailsWithoutEnoughETH() (gas: 22967)
// [PASS] testFundUpdatesFundedDataStructure() (gas: 99464)
// [PASS] testMinimumDollarIsFive() (gas: 5472)
// [PASS] testOnlyOwnerCanWithdraw() (gas: 99946)
// [PASS] testOwnerIsMsgSender() (gas: 5554)
// [PASS] testPriceFeedVersionIsAccurate() (gas: 10679)
// [PASS] testWithDrawFromMultipleFunders() (gas: 488089)
// [PASS] testWithDrawFromMultipleFundersCheaper() (gas: 487124)
// [PASS] testWithdrawFromASingleFunder() (gas: 84464)
// Test result: ok. 10 passed; 0 failed; 0 skipped; finished in 182.75ms

// Running 1 test for test/Integration/InteractionsTest.t.sol:IntegrationsTest
// [PASS] testUserCanFundInteractions() (gas: 563232)
// Test result: ok. 1 passed; 0 failed; 0 skipped; finished in 205.66ms

// Ran 2 test suites: 11 tests passed, 0 failed, 0 skipped (11 total tests)

// forge test --fork-url $SEPOLIA_RPC_URL
// [⠢] Compiling...
// No files changed, compilation skipped

// Running 1 test for test/Integration/InteractionsTest.t.sol:IntegrationsTest
// [PASS] testUserCanFundInteractions() (gas: 570282)
// Test result: ok. 1 passed; 0 failed; 0 skipped; finished in 6.75s

// Running 10 tests for test/unit/FundMeTest.t.sol:FundMeTest
// [PASS] testAddsFunderToArrayOfFunders() (gas: 106754)
// [PASS] testFundFailsWithoutEnoughETH() (gas: 30017)
// [PASS] testFundUpdatesFundedDataStructure() (gas: 106514)
// [PASS] testMinimumDollarIsFive() (gas: 5472)
// [PASS] testOnlyOwnerCanWithdraw() (gas: 106996)
// [PASS] testOwnerIsMsgSender() (gas: 5554)
// [PASS] testPriceFeedVersionIsAccurate() (gas: 16170)
// [PASS] testWithDrawFromMultipleFunders() (gas: 512089)
// [PASS] testWithDrawFromMultipleFundersCheaper() (gas: 511124)
// [PASS] testWithdrawFromASingleFunder() (gas: 90104)
// Test result: ok. 10 passed; 0 failed; 0 skipped; finished in 9.00s

// Ran 2 test suites: 11 tests passed, 0 failed, 0 skipped (11 total tests)

// forge test --fork-url $MAINNET_RPC_URL
// [⠃] Compiling...
// [⠃] Compiling 1 files with 0.8.19
// [⠊] Solc 0.8.19 finished in 7.85s
// Compiler run successful!

// Running 1 test for test/Integration/InteractionsTest.t.sol:IntegrationsTest
// [PASS] testUserCanFundInteractions() (gas: 563232)
// Test result: ok. 1 passed; 0 failed; 0 skipped; finished in 3.52s

// Running 10 tests for test/unit/FundMeTest.t.sol:FundMeTest
// [PASS] testAddsFunderToArrayOfFunders() (gas: 99704)
// [PASS] testFundFailsWithoutEnoughETH() (gas: 22967)
// [PASS] testFundUpdatesFundedDataStructure() (gas: 99464)
// [PASS] testMinimumDollarIsFive() (gas: 5472)
// [PASS] testOnlyOwnerCanWithdraw() (gas: 99946)
// [PASS] testOwnerIsMsgSender() (gas: 5554)
// [PASS] testPriceFeedVersionIsAccurate() (gas: 10679)
// [PASS] testWithDrawFromMultipleFunders() (gas: 488089)
// [PASS] testWithDrawFromMultipleFundersCheaper() (gas: 487124)
// [PASS] testWithdrawFromASingleFunder() (gas: 84464)
// Test result: ok. 10 passed; 0 failed; 0 skipped; finished in 5.10s

// Ran 2 test suites: 11 tests passed, 0 failed, 0 skipped (11 total tests)
