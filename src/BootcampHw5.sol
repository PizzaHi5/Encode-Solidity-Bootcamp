//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract VolcanoCoin is Ownable {
    uint totalSupply = 10000;

    event SupplyChange(uint supply);
    event Transfer(address recipient, uint amount);

    mapping (address => uint) internal balances;
    mapping (address => Payment[]) internal transfers;

    struct Payment {
        uint amount;
        address recipient;
    }

    constructor() {
        balances[msg.sender] = totalSupply;
    }

    function getSupply() public view returns (uint) {
        return totalSupply;
    }

    function increaseTotalSupply() public onlyOwner {
        totalSupply += 1000;
        emit SupplyChange(totalSupply);
    }

    function transfer(uint _amount, address recipient) public {
        emit Transfer(recipient, _amount);
    }
}