//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./BootcampHW7.sol";

contract VolcanoNFT is ERC721("_iDidIt", "IDI"), Ownable {
    uint tokenIdCounter = 0;
    VolcanoCoin coin;

    constructor(address _volcanoCoin) {
        coin = VolcanoCoin(_volcanoCoin);
    }

    function safeMintFree() public {
        _safeMint(msg.sender, tokenIdCounter);
        tokenIdCounter++;
    }

    function safeMintNotFree(uint _amount) public payable {
        uint contractBalance = coin.getBalance(address(this));
        if (msg.value < 10000000000000000 wei) {
            coin.transferFrom(msg.sender, address(this), _amount);
        }
        require(msg.value >= 10000000000000000 wei ||
        coin.getBalance(address(this)) == contractBalance + _amount
        );
        _safeMint(msg.sender, tokenIdCounter);
        tokenIdCounter++;
    }

    //This will allow us to custom edit the tokenURI view function in ERC721
    function _baseURI() internal pure override returns (string memory) {
        return "";
    }

    function returnWei() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

}