// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/BootcampHW19.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract ShameCoinTest is Test {
    using Strings for address;

    ShameCoin public eg;

    function setUp() public {
        eg = new ShameCoin("Shame", "SHM", address(this));
        // Put effort into learning how to log with Foundry
        emit log(string(abi.encodePacked("ShameCoin owner is ", address(this).toHexString())));
        emit log(string(abi.encodePacked("ShameCoin address is ", address(eg).toHexString())));
    }

    function testMint() public {
        eg.mint(msg.sender);
        assertEq(eg.balanceOf(msg.sender), 1);
        emit log_uint(eg.balanceOf(msg.sender));
    }

    function testburn() public {
        
    }
}