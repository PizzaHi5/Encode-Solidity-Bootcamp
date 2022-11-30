// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./interfaces/ISwapRouter.sol";
import "@uniswap/contracts/interfaces/pool/IUniswapV3PoolState.sol";

contract InteractWithUniswap {
    
    function makeASingleSwap(
    address token1, 
    address token2, 
    address pool,
    address router, 
    uint256 amount) 
    public returns (uint256) {
        (uint160 price,,,,,,) = IUniswapV3PoolState(pool).slot0();

        return ISwapRouter(router).exactInputSingle(
            ISwapRouter.ExactInputSingleParams(
            token1,
            token2,
            3000,
            msg.sender,
            99999999,
            amount,
            amount/10,
            price
        ));
    }
}