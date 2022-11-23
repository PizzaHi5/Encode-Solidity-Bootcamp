// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/BootcampHW19.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract ShameCoinTest is Test {
    using Strings for address;
    using Strings for uint256;

    ShameCoin public eg;
    address dummy = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

    function setUp() public {
        eg = new ShameCoin("Shame", "SHM", address(this));
        //emit log(string(abi.encodePacked("ShameCoin owner is ", address(this).toHexString())));
        //emit log(string(abi.encodePacked("ShameCoin address is ", address(eg).toHexString())));
    }

    function testMint() public {
        eg.mint(msg.sender);
        assertEq(eg.balanceOf(msg.sender), 1);
        emit log(string(abi.encodePacked("Number of Tokens Minted: ", eg.balanceOf(msg.sender).toString())));
    }

    function testburn() public {
        //emit log(string(abi.encodePacked("Dummy address is ", dummy.toHexString())));
        eg.mint(dummy);
        emit log(string(abi.encodePacked("Dummy Address Tokens: ", eg.balanceOf(dummy).toString())));

        startHoax(dummy);
        eg.allowAdminBurn();
        assertTrue(eg.canAdminBurn(dummy));
        vm.stopPrank();
        eg.burn(dummy);

        emit log(string(abi.encodePacked("Dummy Address Tokens: ", eg.balanceOf(dummy).toString())));
    }

    function testTransfer() public {
        eg.mint(dummy);
        emit log(string(abi.encodePacked("Dummy Address Tokens: ", eg.balanceOf(dummy).toString())));
        startHoax(dummy);
        eg.transfer(address(eg), 100);
        assertEq(eg.balanceOf(dummy), 2);
        assertEq(eg.balanceOf(address(eg)), 0);
        emit log(string(abi.encodePacked("Dummy Address Tokens: ", eg.balanceOf(dummy).toString())));
        emit log(string(abi.encodePacked("Target Address Tokens: ", eg.balanceOf(address(eg)).toString())));
    }
}