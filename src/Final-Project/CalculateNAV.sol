// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@chainlink/interfaces/AggregatorV2V3Interface.sol";
import "@solmate/src/auth/Owned.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./ICalculateNAV.sol";

/// @notice This contract returns the NAV value based on tracked underlying assets that owner controls
contract CalculateNAV is ICalculateNAV {
    mapping(address => bool) isV3;

    /// @dev Anyone can change this boolean atm
    function registerPriceFeed(address _priceFeed, bool _isV3) external {
        isV3[_priceFeed] = _isV3;
    }

    /// @param _priceFeeds should all have the same denomination (I.E ETH/USD and BTC/USD)
    /// @param _baseToken should be the underlying mintable ETF security
    /// @return nav returns the total price relative to the denominated asset and total baseToken supply
    function calculateNAV(address[] calldata _priceFeeds, address _baseToken) external view returns (int256 nav) {
        int256 total;

        for(uint i = 0; i < _priceFeeds.length; i++) {
            if(isV3[_priceFeeds[i]]) {
                total += getV3Price(_priceFeeds[i]);
            } if(!isV3[_priceFeeds[i]]) {
                total += getV2Price(_priceFeeds[i]);
            } else {
                revert(string(abi.encode("Non-registered address: ", _priceFeeds[i])));
            }
        }
        nav = total / int256(IERC20(_baseToken).totalSupply());
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
}