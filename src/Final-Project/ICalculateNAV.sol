// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

interface ICalculateNAV {
    function registerPriceFeed(address _priceFeed, bool _isV3) external;
    function calculateNAV(address[] calldata _priceFeeds, address _baseToken) external view returns (int256 nav);
}