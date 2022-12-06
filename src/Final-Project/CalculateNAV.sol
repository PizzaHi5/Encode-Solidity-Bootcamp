// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@chainlink/interfaces/AggregatorV2V3Interface.sol";
import "@solmate/src/auth/Owned.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./ICalculateNAV.sol";

/// @notice This contract returns the NAV value based on tracked underlying assets that owner controls
contract CalculateNAV is ICalculateNAV {
    /** 
        @param priceFeeds should all have the same denomination (I.E ETH/USD and BTC/USD)
        @param tokens is constructed array from priceFeeds. Always contains 1 less index than priceFeeds
        @param baseToken should be the underlying mintable ETF security
        @return nav returns the total price relative to the denominated asset and total baseToken supply
    */
    function calculateNAV(
        address[] calldata priceFeeds,
        address[] calldata tokens,
        address baseToken
        ) external view returns (int256 nav) {
        int256 holdingValue;

        for(uint i = 0; i < priceFeeds.length; i++) {
            // value += price * token amount
            if(i==0) {
            // index 0 will be ETH since its called differently
            holdingValue += formatPriceFeedDecimals(getV3Price(priceFeeds[i])) * int256(msg.sender.balance);
            } else {
            // ERC20 compliant tokens
            holdingValue += formatPriceFeedDecimals(getV3Price(priceFeeds[i])) * int256(IERC20(tokens[i-1]).balanceOf(msg.sender));
            }
        }
        nav = holdingValue / int256(IERC20(baseToken).totalSupply());
    }

    /// @dev Formatted getters for price
    function getV3Price(address priceFeed) public view returns (int256 price) {
        (, price,,,) = AggregatorV3Interface(priceFeed).latestRoundData();
        //format data here
    }

    function getV2Price(address priceFeed) public view returns (int256 price) {
        //format data here;
        return AggregatorInterface(priceFeed).latestAnswer();
    }

    /// @dev read off ERC20 decimals later, openzeppelin IERC20 doesnt have it
    ///      should need token
    function formatPriceFeedDecimals(int256 feedPrice) private pure returns (int256) {
        return feedPrice * 10**(18 - 8);
    }
}