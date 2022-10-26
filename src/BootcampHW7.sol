//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract VolcanoCoin is Ownable {
    uint totalSupply = 10000;

    event SupplyChange(uint supply);
    event Transfer(address recipient, uint amount);

    mapping (address => uint) internal balances;
    mapping (address => Payment[]) internal payments;

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

    function recordPayment(address _sender, address _receiver, uint _amount) public {
        Payment memory _payments;
        _payments.amount = _amount;
        _payments.recipient = _receiver;
        payments[_sender].push(_payments);
    }

    function transfer(uint _amount, address recipient) public {
        recordPayment(msg.sender, recipient, _amount);
        emit Transfer(recipient, _amount);
    }

    // Thought of this for fun
    function reconstructPaymentArray(Payment[] memory payments) 
        private 
        pure 
        returns (
        Payment[] memory, 
        uint lastSlot
        ) {
        uint i;
        for(i = 0; i < payments.length; i++) {
            //Got to think of this part still
        }
        return (payments, i);
    }
}