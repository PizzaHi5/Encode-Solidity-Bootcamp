// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@solmate/src/tokens/ERC20.sol";
import "@solmate/src/auth/Owned.sol";
import { ICalculateNAV } from "./CalculateNAV.sol";

contract ETFERC20 is ERC20, Owned(msg.sender) {
    address[] public trackedPriceFeeds;
    address public calcNav;

    constructor(
    string memory _name, 
    string memory _symbol, 
    uint8 _decimals, 
    address _calcNav
    ) ERC20 (_name, _symbol, _decimals) {
        calcNav =_calcNav;
    }

    function mint(uint256 amount) public payable {
        require(msg.value >= amount * uint256(ICalculateNAV(calcNav).calculateNAV(trackedPriceFeeds, address(this))));
        _mint(msg.sender, amount);
    }

    function burn(uint256 amount) public payable {
        require(balanceOf[msg.sender] >= amount);
        _burn(msg.sender, amount);
        //return locked eth to sender
    }

    function addTrackedPriceFeeds(address priceFeed, bool isV3) external onlyOwner {
        //require IsContract
        trackedPriceFeeds.push(priceFeed);
        ICalculateNAV(calcNav).registerPriceFeed(priceFeed, isV3);
    }

    function updateCalcNav(address _calcNav) external onlyOwner {
        calcNav = _calcNav;
    }
}