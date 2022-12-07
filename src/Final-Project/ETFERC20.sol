// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@solmate/src/tokens/ERC20.sol";
import "@solmate/src/auth/Owned.sol";
import { ICalculateNAV } from "./CalculateNAV.sol";

contract ETFERC20 is ERC20, Owned(msg.sender) {
    address[] public trackedPriceFeeds;
    address[] public tokens;
    address public calcNav;

    //require constructor to also include msg.value to set starting share value
    constructor(
    string memory _name, 
    string memory _symbol, 
    uint8 _decimals,
    uint256 amount,
    address _calcNav
    ) ERC20 (_name, _symbol, _decimals) {
        calcNav =_calcNav;
        _mint(msg.sender, amount);
    }

    function mintWithEth(uint256 amount) public payable {
        require(msg.value >= amount * uint256(ICalculateNAV(calcNav).calculateNAV(
            trackedPriceFeeds, 
            tokens, 
            address(this))));

        _mint(msg.sender, amount);
    }

    function mintWithRegisterToken(uint256 amount, address token) public payable {
        //insert logic here
    }

    function burn(uint256 amount) public payable {
        require(balanceOf[msg.sender] >= amount);
        _burn(msg.sender, amount);
        //return locked eth to sender
    }

    function checkNAV() external view returns (int256) {
        return ICalculateNAV(calcNav).calculateNAV(
            trackedPriceFeeds, 
            tokens, 
            address(this));
    }

    /// @dev Sets index 0 to always be the ETH pricefeed
    function addETHPriceFeed(address priceFeed) external onlyOwner {
        //check if priceFeeds has values, if does, set index 0 instead of push
        trackedPriceFeeds.push(priceFeed);

    }

    function addTrackedPriceFeeds(address priceFeed, address feedToken) external onlyOwner {
        //require IsContract
        trackedPriceFeeds.push(priceFeed);
        tokens.push(feedToken);
    }

    function updateCalcNav(address _calcNav) external onlyOwner {
        calcNav = _calcNav;
    }
}