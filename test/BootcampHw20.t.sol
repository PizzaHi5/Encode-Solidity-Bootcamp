// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "src/interfaces/ISwapRouter.sol";
import "src/BootcampHW21.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@uniswap/contracts/interfaces/IUniswapV3Factory.sol";

/**  @notice This contract makes calls to defined mainnet addresses and tests
        for 2 exactInputSingle swaps from DAI to USDC and DAI to BUSD
*/ 
contract UniswapTest is Test {
    using Strings for address;
    using Strings for uint256;

    address constant router = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    address constant dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address constant busd = 0xDFd5293D8e347dFe59E90eFd55b2956a1343963d;
    address constant usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    address constant uniFactory = 0x1F98431c8aD98523631AE4a59f267346ea31F984;
    InteractWithUniswap eg;

    //stuck, need to figure out how to get cast to deploy/call these test contract methods
    function setUp() public {
        eg = new InteractWithUniswap();
    }

    /// @dev 2 Unit tests for makeASingleSwap for Homework 21
    function testMakeABUSDSwap() public {
        /// @param fee The fee collected upon every swap in the pool, denominated in hundredths of a bip
        //address pool = IUniswapV3Factory(uniFactory).getPool(dai, busd, 3000); //3000 = 3% fee in bip?

        uint256 amount = eg.makeASingleSwap(dai, busd, router, 100);
        assertTrue(amount >= 0);
        emit log_bytes(abi.encodePacked("Swapped: ", amount.toHexString()));
        emit log_bytes(abi.encodePacked("BUSD Balance: ", IERC20(busd).balanceOf(address(this)).toHexString()));
    }

    function testMakeAUSDCSwap() public {
        //address pool = IUniswapV3Factory(uniFactory).getPool(dai, usdc, 3000);

        uint256 amount = eg.makeASingleSwap(dai, usdc, router, 100);
        assertTrue(amount > 0);
        emit log_bytes(abi.encodePacked("Swapped: ", amount.toHexString()));
        emit log_bytes(abi.encodePacked("USDC Balance: ", IERC20(usdc).balanceOf(address(this)).toHexString()));
    }

    /**
        @dev Wrote these address calls for Hw20
           Swapping DAI for USDC using address calls
    */
    function testExactInputSingleDAItoUSDC() public {
    startHoax(busd);
    (bool temp, bytes memory data) = router.call(abi.encodeWithSignature(
        "exactInputSingle(ExactInputSingleParams)", 
        ISwapRouter.ExactInputSingleParams(
            dai,
            usdc,
            3000,
            msg.sender,
            99999999,
            100,
            0,
            0
        )
    ));
    assertTrue(temp, "Router call failed");
    emit log_bytes(data);

    /// @dev Checking USDC balance post swap
    (temp, data) = usdc.call(abi.encodeWithSignature("balanceOf(address)", address(this)));
    assertTrue(temp, "USDC call failed");
    emit log_bytes(data);
    }

    /// @dev Swapping DAI to BUSD using address calls
    function testExactInputSingleDAItoBUSD() public {
    startHoax(busd);
    (bool temp, bytes memory data) = router.call(abi.encodeWithSignature(
        "exactInputSingle(ExactInputSingleParams)", 
        ISwapRouter.ExactInputSingleParams(
            dai,
            busd,
            3000,
            msg.sender,
            99999999,
            100,
            0,
            0
        )
    ));
    assertTrue(temp, "Router call failed");
    emit log_bytes(data);

    /// @dev Checking DAI balance post swap
    (temp, data) = dai.call(abi.encodeWithSignature("balanceOf(address)", address(this)));
    assertTrue(temp, "DAI call failed");
    emit log_bytes(data);
    }
}