// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/BootcampHW19.sol";

contract ShameCoinTest is Test {

    ShameCoin public eg;

    function setUp(string memory _name, string memory _symbol) public {
        eg = new ShameCoin(_name, _symbol, address(this));
        emit log(string(abi.encodePacked("ShameCoin owner is ", address(this))));
    }

    function testMint() public {
        eg.mint(msg.sender);
        assertEq(eg.balanceOf(msg.sender), 1);
        emit log_uint(eg.balanceOf(msg.sender));
    }

    function testburn() public {
        
    }
}