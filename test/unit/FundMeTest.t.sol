// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @notice We have to keep in mind that when we write our test, every test block start from beginning
 * The reason is bcos it is not reading from any state. So we have to always set up our state
 * before we can run our test
 */

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    /**
     * @dev "makeAddr("user");" --> We create a user who will run our test. the reason is
     * bcos we dont want FundMeText to be the default address that will run the test i.e address(this)
     * we want "USER"
     */
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether; // 100000000000000000
    uint256 constant STARTING_USER_BALANCE = 10 ether;

    /**
     * @notice I commented "function testWithdrawFromASingleFunder()" bcos i want to test it
     * seperately
     * @notice GAS_PRICE --> I used the variable in this test i.e "function testWithdrawFromASingleFunder()"
     * @dev GAS_PRICE --> we want to use it to test our "function testWithdrawFromASingleFunder()"
     * bcos we want to know the amount of gas it cost to run the test also not to default
     * the balance to zero
     */
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_USER_BALANCE); // We give 10 ether to the user
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public {
        assertEq(fundMe.getVersion(), 4);
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert();
        fundMe.fund();
    }

    /**
     * @notice testFundUpdatesFundedDataStructure()
     * @dev This test pass but we dont want FundMeTest to be the user that send the transaction
     * we want the owner to send the transaction
     *
     * function testFundUpdatesFundedDataStructure() public {
     *     fundMe.fund{value: 10e18}();
     *     uint256 amountFunded = fundMe.getAddressToAmountFunded(address(this));
     *     assertEq(amountFunded, 10e18);
     * }
     */

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER); // The next Tx will be sent by user
        fundMe.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    /**
     * @notice testOnlyOwnerCanWithdraw()
     * @dev we purposely did "vm.expectRevert();" before "fundMe.withdraw();" bcos when it do
     * "vm.prank(USER);" it will check the above way i arranged it
     */
    function testOnlyOwnerCanWithdraw() public funded {
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawFromASingleFunder() public funded {
        // Arrange --> we arrange the test
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMebalance = address(fundMe).balance;

        // Act --> we act on the thing we want to test
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        // Assert --> we assert the result of the act
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMebalance = address(fundMe).balance;
        assertEq(endingFundMebalance, 0);
        assertEq(startingFundMebalance + startingOwnerBalance, endingOwnerBalance);
    }

    /**
     * @notice we would notice that when we run our test the balance dosent change, the reason is bcos
     * when we work with anvil chain the balance default to zero, meaning our transaction dosent cost
     * gas.
     * @dev if we want our Tx to cost gas which will change our balance when is good like it is on a real
     * blockchain, we have to use a cheat code called "txGasPrice()"
     *
     * So this specific will use that feature where our Tx will cost gas and our balance will be reduced
     * and not be defaulted to zero
     * function testWithdrawFromASingleFunder() public funded {
     *     // Arrange --> we arrange the test
     *     uint256 startingOwnerBalance = fundMe.getOwner().balance;
     *     uint256 startingFundMebalance = address(fundMe).balance;
     *
     *     // Act --> we act on the thing we want to test
     *     uint256 gasStart = gasleft(); // gasLeft is a built in function in solidity that will tell us how much gas we have left
     *     vm.txGasPrice(GAS_PRICE); // we use this cheat code to know the amount of gas it cost to run the test
     *
     *     vm.prank(fundMe.getOwner());
     *     fundMe.withdraw();
     *
     *     uint256 gasEnd = gasleft();
     *     uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice; // tx.gasprice is a built in function in solidity that will tell us the gas price
     *     console.log(gasUsed);
     *
     *     // Assert --> we assert the result of the act
     *     uint256 endingOwnerBalance = fundMe.getOwner().balance;
     *     uint256 endingFundMebalance = address(fundMe).balance;
     *     assertEq(endingFundMebalance, 0);
     *     assertEq(startingFundMebalance + startingOwnerBalance, endingOwnerBalance);
     *
     *     // The result of our test
     *
     *     // forge test --mt testWithdrawFromASingleFunder -vv
     *     // [⠊] Compiling...
     *     // [⠔] Compiling 1 files with 0.8.19
     *     // [⠑] Solc 0.8.19 finished in 7.37s
     *     // Compiler run successful!
     *
     *     // Running 1 test for test/unit/FundMeTest.t.sol:FundMeTest
     *     // [PASS] testWithdrawFromASingleFunder() (gas: 87276)
     *     // Logs:
     *     //   10653
     *
     *     // Test result: ok. 1 passed; 0 failed; 0 skipped; finished in 205.89ms
     *
     *     // Ran 1 test suites: 1 tests passed, 0 failed, 0 skipped (1 total tests)
     * }
     */

    /**
     * @dev we want to set a new address for vm.prank and vm.deal
     * "hoax" is prank + deal combined
     * i.e hoax(<some address>, value)
     *
     * we use uint160, bcos from stackoverflow.com/questions/43318077/solidity-type...
     * as of Solidity v0.8, you can no longer cast explicitly
     * from address to uint256.
     * you can use uint256 i = uint256(uint160(msg.sender));
     *
     * address(i) --> we set a new address for vm.prank and new value for vm.deal
     *
     * fundMe.fund{value: SEND_VALUE}(); --> we fund our contract
     *
     * vm.prank() and vm.startPrank() works the same
     */
    function testWithDrawFromMultipleFunders() public funded {
        // Arrange --> we arrange the test
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMebalance = address(fundMe).balance;

        // Act --> we act on the thing we want to test
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        // Assert --> we assert the result of the act
        assert(address(fundMe).balance == 0);
        assert(startingFundMebalance + startingOwnerBalance == fundMe.getOwner().balance);
    }

    /**
     * @dev testWithDrawFromMultipleFundersCheaper() is the same as testWithDrawFromMultipleFunders
     * we only change "fundMe.withdraw();" to "fundMe.cheaperWithdraw();"
     *
     * When we run forge snapshot, we would see that it cost less gas
     */
    function testWithDrawFromMultipleFundersCheaper() public funded {
        // Arrange --> we arrange the test
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMebalance = address(fundMe).balance;

        // Act --> we act on the thing we want to test
        vm.startPrank(fundMe.getOwner());
        fundMe.cheaperWithdraw();
        vm.stopPrank();

        // Assert --> we assert the result of the act
        assert(address(fundMe).balance == 0);
        assert(startingFundMebalance + startingOwnerBalance == fundMe.getOwner().balance);
    }
}

// forge test
// [⠆] Compiling...
// No files changed, compilation skipped

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
// Test result: ok. 10 passed; 0 failed; 0 skipped; finished in 56.66ms

// Ran 1 test suites: 10 tests passed, 0 failed, 0 skipped (10 total tests)

// forge test --mt testWithDrawFromMultipleFunders
// [⠊] Compiling...
// [⠆] Compiling 1 files with 0.8.19
// [⠔] Solc 0.8.19 finished in 7.31s
// Compiler run successful!

// Running 1 test for test/unit/FundMeTest.t.sol:FundMeTest
// [PASS] testWithDrawFromMultipleFunders() (gas: 488107)
// Test result: ok. 1 passed; 0 failed; 0 skipped; finished in 6.48ms

// Ran 1 test suites: 1 tests passed, 0 failed, 0 skipped (1 total tests)

// forge test --mt testOwnerIsMsgSender -vvvv
// [⠒] Compiling...
// [⠰] Compiling 1 files with 0.8.19
// [⠒] Solc 0.8.19 finished in 8.28s
// Compiler run successful!

// Running 1 test for test/unit/FundMeTest.t.sol:FundMeTest
// [PASS] testOwnerIsMsgSender() (gas: 5554)
// Traces:
//   [5554] FundMeTest::testOwnerIsMsgSender()
//     ├─ [202] FundMe::getOwner() [staticcall]
//     │   └─ ← DefaultSender: [0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38]
//     └─ ← ()

// Test result: ok. 1 passed; 0 failed; 0 skipped; finished in 6.01ms

// Ran 1 test suites: 1 tests passed, 0 failed, 0 skipped (1 total tests)

// To know the amount of gas it cost to run the test "testOwnerIsMsgSender"

// forge snapshot --mt testOwnerIsMsgSender
// [⠢] Compiling...
// [⠔] Compiling 1 files with 0.8.19
// [⠒] Solc 0.8.19 finished in 7.25s
// Compiler run successful!

// Running 1 test for test/unit/FundMeTest.t.sol:FundMeTest
// [PASS] testOwnerIsMsgSender() (gas: 5554)
// Test result: ok. 1 passed; 0 failed; 0 skipped; finished in 4.79ms

// Ran 1 test suites: 1 tests passed, 0 failed, 0 skipped (1 total tests)

// forge snapshot
// [⠰] Compiling...
// [⠑] Compiling 1 files with 0.8.19
// [⠃] Solc 0.8.19 finished in 10.42s
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
// Test result: ok. 10 passed; 0 failed; 0 skipped; finished in 7.77ms

// Ran 1 test suites: 10 tests passed, 0 failed, 0 skipped (10 total tests)
