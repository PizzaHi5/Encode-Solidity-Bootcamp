// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import "@solmate/src/tokens/ERC20.sol";
import "@solmate/src/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

/// @notice A standardized implementation rather than what was done
///     for BootcampHW7 and 11. 
contract VolcanoCoin is ERC20, ReentrancyGuard, Pausable {
    uint public nameLength;

    constructor(
    string memory _name, 
    string memory _symbol,
    uint8 _decimals
    ) 
    ERC20(_name, _symbol, _decimals) {
        (_name, nameLength) = addETHDenver(_name);
    }

    function addETHDenver (string memory _string) internal nonReentrant whenNotPaused 
    returns (string memory string_, uint) {
        string_ = string.concat(_string, " from ETH Denver");
        return (string_, bytes(string_).length);
    }
}