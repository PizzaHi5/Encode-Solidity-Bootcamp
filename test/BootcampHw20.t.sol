// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "src/interfaces/ISwapRouter.sol";
import "src/BootcampHW21.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@uniswap/contracts/interfaces/IUniswapV3Factory.sol";

/**  @notice This contract makes calls to defined mainnet addresses and tests
        for 2 exactInputSingle swaps from DAI to USDC and DAI to binance
*/ 
contract UniswapTest is Test {
    using Strings for address;
    using Strings for uint256;

    address constant router = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    address constant dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address constant busd = 0x4Fabb145d64652a948d72533023f6E7A623C7C53;
    //this is a holder address, not the token
    address constant binance = 0xDFd5293D8e347dFe59E90eFd55b2956a1343963d;
    address constant usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    address constant uniFactory = 0x1F98431c8aD98523631AE4a59f267346ea31F984;
    InteractWithUniswap eg;

    function setUp() public {
        eg = new InteractWithUniswap();
    }

    /* Tried very hard to get these swaps to work, was not successful.
        I was able to call the router contract directly with the values listed
        and that succeeded in swapping. These swaps use a lot of gas so 
        something is going on correctly and failing along the way. Used SideKik.xyz
        to make the router contract call directly. 

        Note to Self: Going to try hardhats console.log next time
    */

    /// @dev 2 Unit tests for makeASingleSwap for Homework 21
    function testMakeABusdSwap() public {
        /// @param fee The fee collected upon every swap in the pool, denominated in hundredths of a bip
        //address pool = IUniswapV3Factory(uniFactory).getPool(dai, binance, 3000); //300 = 3% fee in bip?
        uint24 fee = 3000;
        emit log(string(abi.encodePacked("Binance before DAI balance: ", IERC20(dai).balanceOf(binance).toString())));
        emit log(string(abi.encodePacked("Binance before BUSD balance: ", IERC20(busd).balanceOf(binance).toString())));
        
        vm.startPrank(binance);
        uint256 amount = eg.makeASingleSwap(dai, busd, router, 1000, fee);

        assertTrue(amount >= 0);
        emit log(string(abi.encodePacked("Binance after DAI balance: ", IERC20(dai).balanceOf(binance).toString())));
        emit log(string(abi.encodePacked("Binance after BUSD balance: ", IERC20(busd).balanceOf(binance).toString())));
    }

    function testMakeAUSDCSwap() public {
        //address pool = IUniswapV3Factory(uniFactory).getPool(dai, usdc, 3000);
        uint24 fee = 3000;
        emit log(string(abi.encodePacked("Binance before DAI balance: ", IERC20(dai).balanceOf(binance).toString())));
        emit log(string(abi.encodePacked("Binance before USDC balance: ", IERC20(usdc).balanceOf(binance).toString())));
        
        vm.startPrank(binance);
        uint256 amount = eg.makeASingleSwap(dai, usdc, router, 1000, fee);
        
        assertTrue(amount >= 0);
        emit log(string(abi.encodePacked("Binance after DAI balance: ", IERC20(dai).balanceOf(binance).toString())));
        emit log(string(abi.encodePacked("Binance after USDC balance: ", IERC20(usdc).balanceOf(binance).toString())));
   }

    /**
        @dev Wrote these address calls for Hw20
           Swapping DAI for USDC using address calls
    */
    function testExactInputSingleDAItoUSDC() public {
    (bool temp, bytes memory data) = router.call(abi.encodeWithSelector(
        0x414bf389, //got selector off Uniswap Router on etherscan
        ISwapRouter.ExactInputSingleParams({
            tokenIn: dai,
            tokenOut: usdc,
            fee: 3000,
            recipient: msg.sender,
            deadline: getMaxUint256(),
            amountIn: 10,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0
        })
    ));
    /// @dev Checking USDC balance post swap
    (temp, data) = usdc.call(abi.encodeWithSignature("balanceOf(address)", address(this)));
    }

    /// @dev Swapping DAI to busd using address calls
    function testExactInputSingleDAItoBUSD() public {
    (bool temp, bytes memory data) = router.call(abi.encodeWithSelector(
        0x414bf389, //got selector off Uniswap Router on etherscan
         ISwapRouter.ExactInputSingleParams({
            tokenIn: dai,
            tokenOut: busd,
            fee: 3000,
            recipient: msg.sender,
            deadline: getMaxUint256(),
            amountIn: 10,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0
        })
    ));
    /// @dev Checking DAI balance post swap
    (temp, data) = dai.call(abi.encodeWithSignature("balanceOf(address)", address(this)));
    }

    function getMaxUint256() public pure returns (uint256) {
        unchecked {
            return uint256(0) - 1;
        }
    }
}