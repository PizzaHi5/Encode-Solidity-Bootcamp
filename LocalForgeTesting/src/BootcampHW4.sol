//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract VolcanoCoin {
    uint totalSupply = 10000;

    function getSupply() public view returns (uint) {
        return totalSupply;
    }

    
}