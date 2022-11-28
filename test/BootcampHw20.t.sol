// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "src/interfaces/ISwapRouter.sol";


contract UniswapTest is Test {
    using Strings for address;
    using Strings for uint256;

    address constant router = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    address constant dai = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address constant busd = 0xDFd5293D8e347dFe59E90eFd55b2956a1343963d;
    address constant usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    function setUp() public {
        
    }

    /// @dev Swapping DAI for USDC
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

    /// @dev Swapping DAI to BUSD
    function testExactInputSingleDAItoBUSD() public {

    //emit log(string(abi.encodePacked("Target Address Tokens: ", busd.balanceOf(address(this)).toString())));

    }
}