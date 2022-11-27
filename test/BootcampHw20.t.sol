// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract UniswapTest is Test {

    address router = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    address dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address busd = 0xDFd5293D8e347dFe59E90eFd55b2956a1343963d;
    address usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    /// @dev copied from ISwapRouter
    struct ExactInputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
        uint160 sqrtPriceLimitX96;
    }

    function setUp() public {

    }

    /// @dev Swapping DAI for USDC
    function testExactInputSingleDAItoUSDC() public {


    }

    /// @dev Swapping DAI to BUSD
    function testExactInputSingleDAItoBUSD() public {

    }
}