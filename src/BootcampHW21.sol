// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./interfaces/ISwapRouter.sol";
import "@uniswap/contracts/interfaces/pool/IUniswapV3PoolState.sol";

/// @notice This is intended to make a single swap that anyone can call
contract InteractWithUniswap {
    /// @dev Commented out pool info, ran into issues with executing
    function makeASingleSwap(
    address token1, 
    address token2, 
    //address pool,
    address router, 
    uint256 amount,
    uint24 fee) 
    public returns (uint256) {
        //(uint160 price,,,,,,) = IUniswapV3PoolState(pool).slot0();

        return ISwapRouter(router).exactInputSingle(
            ISwapRouter.ExactInputSingleParams(
            token1,
            token2,
            fee,
            msg.sender,
            getMaxUint256(),
            amount,
            0,
            0 //price
        ));
    }

    function getMaxUint256() public pure returns (uint256) {
        unchecked {
            return uint256(0) - 1;
        }
    }
}