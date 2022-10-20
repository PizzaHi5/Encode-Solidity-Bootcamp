// SPDX-License-Identifier: None

pragma solidity 0.8.17;

// This contract is for Homework 3.txt

contract BootcampContract {

    uint256 number;
    address owner;

    constructor() {
        owner = msg.sender;
    }

    function store(uint256 num) public {
        number = num;
    }

    function retrieve() public view returns (uint256){
        return number;
    }

    function trueOwnerAddress() external view returns (address) {
        if(msg.sender == owner) {
            return 0x000000000000000000000000000000000000dEaD;
        } else {
            return owner;
        }
    }
}