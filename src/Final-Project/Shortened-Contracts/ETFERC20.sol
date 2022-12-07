// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.17;

import "@solmate/src/tokens/ERC20.sol";
import "./Spoke.sol";
import { ICalculateNAV } from "./ICalculateNAV.sol";

/** 
    @notice This contract creates a ERC721 Spoke that can be bought/sold
        that generates ERC20 tokens representing shares in held contract
        assets.
    @dev This contract is incomplete and not recommended for production
*/
contract ETFERC20 is ERC20, Spoke {
    address[] public trackedPriceFeeds;
    address[] public tokens;
    address public calcNav;
    string public tokenURI;

    constructor(
    string memory _name, 
    string memory _symbol, 
    uint8 _decimals,
    uint256 _amount,
    uint256 _tokenId,
    address _owner,
    address _calcNav
    )
    ERC20 (_name, _symbol, _decimals) 
    Spoke (_owner, _tokenId)
    payable
    {
        require(msg.value > 0);
        require(_amount > 0);
        calcNav =_calcNav;
        _mint(_owner, _amount);
    }

    //
    //  EXTERNAL PAYABLE
    //

    /// @notice Allows minting of tokens at NAV value with Eth
    function mintWithEth(uint256 amount) external payable {
        require(msg.value >= amount * uint256(ICalculateNAV(calcNav).calculateNAV(
            trackedPriceFeeds, 
            tokens, 
            address(this))));

        _mint(msg.sender, amount);
    }

    //
    //  EXTERNAL VIEW
    //

    function checkNAV() external view returns (int256) {
        return ICalculateNAV(calcNav).calculateNAV(
            trackedPriceFeeds, 
            tokens, 
            address(this));
    }

    //
    //  EXTERNAL ONLY-OWNER
    //

    function setName(string memory _name) external onlyOwner {
        require(msg.sender == owner);
        name = _name;
    }

    function setTokenURI(string memory _tokenURI) external onlyOwner {
        require(msg.sender == owner);
        tokenURI = _tokenURI;
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

    function returnEth() external payable onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }
}