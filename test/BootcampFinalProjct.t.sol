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
    using Strings for uint256;

    ETFERC20 eg;
    CalculateNAV ek;
    address[] priceFeeds = [
        0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419, //ETH/USD, 3600s heartbeat, 8 decimals
        0x2c1d072e956AFFC0D435Cb7AC38EF18d24d9127c, //LINK/USD, 3600s heartbeat, 8 decimals
        0x553303d460EE0afB37EdFf9bE42922D8FF63220e, //UNI/uSD, 3600s heartbeat, 8 decimals
        0x7bAC85A8a13A4BcD8abb3eB7d6b4d632c5a57676  //MATIC/USD, 3600s heartbeat, 8 decimals
        ];

    address[] tokens = [
        //0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599, //WBTC, 8 decimals
        0x514910771AF9Ca656af840dff83E8264EcF986CA, //LINK, 18 decimals
        0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984, //UNI, 18 decimals
        0x7D1AfA7B718fb893dB30A3aBc0Cfc608AaCfeBB0  //MATIC, 18 decimals
        ];

    function setUp() public {
        ek = new CalculateNAV();
        eg = new ETFERC20{value: 1 ether}("StarterETF", "ETF", 18, 1, 0, address(this), address(ek));
    }

    function testAddETHPriceFeed() public {
        eg.addETHPriceFeed(priceFeeds[0]);
    }

    function testCalculateNAV() public {
        eg.addETHPriceFeed(priceFeeds[0]);
        eg.addTrackedPriceFeeds(priceFeeds[1], tokens[0]);
        eg.addTrackedPriceFeeds(priceFeeds[2], tokens[1]);
        eg.addTrackedPriceFeeds(priceFeeds[3], tokens[2]);

        emit log_int(ek.getV3Price(priceFeeds[0]));

        int nav = ek.calculateNAV(priceFeeds, tokens, address(eg));
        emit log_int(nav);
    }

    function testMintWithEth() public {
        eg.addETHPriceFeed(priceFeeds[0]);
        uint amount = eg.balanceOf(msg.sender);
        emit log_bytes(abi.encodePacked("Current Balance ", eg.balanceOf(msg.sender).toHexString()));
        eg.mintWithEth{value: 1 * uint256(ek.calculateNAV(priceFeeds, tokens, address(eg)))}(1);
        assertEq(eg.balanceOf(msg.sender), amount + 1);
        emit log_bytes(abi.encodePacked("New Balance ", eg.balanceOf(msg.sender).toHexString()));
    }
}