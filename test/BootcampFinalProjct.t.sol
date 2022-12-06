// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "src/Final-Project/CalculateNav.sol";
import "src/Final-Project/ETFERC20.sol";

/**  @notice This contract tests the output of ETF calculation from
        inputted priceFeeds. Must run on forked mainnet
*/ 
contract ETFERC20Test is Test {
    ETFERC20 eg;
    CalculateNAV ek;
    address[] priceFeeds = [
        0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419, //ETH/USD, 3600s heartbeat, 8 decimals
        0xF4030086522a5bEEa4988F8cA5B36dbC97BeE88c, //BTC/USD, 3600s heartbeat, 8 decimals
        0x2c1d072e956AFFC0D435Cb7AC38EF18d24d9127c, //LINK/USD, 3600s heartbeat, 8 decimals
        0x4ffC43a60e009B551865A93d232E33Fce9f01507, //SOL/uSD, 86400s heartbeat, 8 decimals
        0x14e613AC84a31f709eadbdF89C6CC390fDc9540A  //BNB/USD, 86400s heartbeat, 8 decimals
        ];

    function setUp() public {
        ek = new CalculateNAV();
        eg = new ETFERC20("StarterETF", "ETF", 18, 1000000*10**18, address(ek));
    }

    function testAddTrackedPriceFeeds() public {
        eg.addTrackedPriceFeeds(priceFeeds[0], true);
    }

    function testCalculateNAV() public {
        eg.addTrackedPriceFeeds(priceFeeds[0], true);
        eg.addTrackedPriceFeeds(priceFeeds[1], true);
        eg.addTrackedPriceFeeds(priceFeeds[2], true);
        eg.addTrackedPriceFeeds(priceFeeds[3], true);
        eg.addTrackedPriceFeeds(priceFeeds[4], true);

        //figure out whats going on here
        int nav = ek.calculateNAV(priceFeeds, address(eg));
        emit log_int(nav);
    }

    function testMint() public {
        uint amount = eg.balanceOf(msg.sender);
        eg.mint{value: 1 * uint256(ek.calculateNAV(priceFeeds, address(eg)))}(1);
        assertEq(eg.balanceOf(msg.sender), amount + 1);
        emit log(string(abi.encode("New Balance ", eg.balanceOf(msg.sender))));
    }
}