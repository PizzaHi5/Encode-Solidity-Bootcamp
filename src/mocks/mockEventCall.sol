// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.7.6;
pragma abicoder v2;

import "./IExchange.sol";

contract mockEventcall is IExchange {

    function emitFundingUpdated(uint _mktPrice, uint _idxPrice) public {
        emit FundingUpdated (msg.sender, _mktPrice, _idxPrice);
    }

    function getMaxTickCrossedWithinBlock(address baseToken) external override view returns (uint24 maxTickCrossedWithinBlock) {}

    /// @notice Get all the pending funding payment for a trader
    /// @return pendingFundingPayment The pending funding payment of the trader.
    /// Positive value means the trader pays funding, negative value means the trader receives funding.
    function getAllPendingFundingPayment(address trader) external override view returns (int256 pendingFundingPayment) {}

    /// @notice Check if current price spread between market price and index twap is over maximum price spread.
    /// @param baseToken Address of the base token
    /// @return true if over the maximum price spread
    function isOverPriceSpread(address baseToken) external override view returns (bool) {}

    /// @notice Get the pending funding payment for a trader in a given market
    /// @dev this is the view version of _updateFundingGrowth()
    /// @return pendingFundingPayment The pending funding payment of a trader in one market,
    /// including liquidity & balance coefficients. Positive value means the trader pays funding,
    /// negative value means the trader receives funding.
    function getPendingFundingPayment(address trader, address baseToken)
        external
        override
        view
        returns (int256 pendingFundingPayment) {}

    /// @notice Get the square root of the market twap price with the given time interval
    /// @dev The return value is a X96 number
    /// @param baseToken Address of the base token
    /// @param twapInterval The time interval in seconds
    /// @return sqrtMarkTwapX96 The square root of the market twap price
    function getSqrtMarkTwapX96 (address baseToken, uint32 twapInterval) external override view returns (uint160 sqrtMarkTwapX96){}

    /// @notice Get `OrderBook` contract address
    /// @return orderBook `OrderBook` contract address
    function getOrderBook() external override view returns (address orderBook) {}

    /// @notice Get `AccountBalance` contract address
    /// @return accountBalance `AccountBalance` contract address
    function getAccountBalance() external override view returns (address accountBalance) {}

    /// @notice Get `ClearingHouseConfig` contract address
    /// @return clearingHouse `ClearingHouseConfig` contract address
    function getClearingHouseConfig() external override view returns (address clearingHouse){}
}
