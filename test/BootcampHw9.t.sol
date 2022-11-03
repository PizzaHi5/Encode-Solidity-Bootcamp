// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/mocks/BootcampHW9.sol";

contract VolcanoNFTTest is Test {

    VolcanoNFT public eg;

    function setUp() public {
        eg = new VolcanoNFT();
        emit log_uint(eg.getBalance(address(this)));
    }

    function testIncreaseSupply() public {
        uint currentSupply = eg.getSupply();
        eg.increaseTotalSupply();
        emit log_uint(eg.getSupply());
        assertEq(currentSupply + 1000, eg.getSupply());
    }

    function testMintNFT(address _to) public {
        //minted/transfered on remix in Goerli Testnet
    }
}
