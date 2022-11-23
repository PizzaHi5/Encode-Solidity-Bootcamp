//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title This contract creates ShameTokens distrubuted by an admin
/// @author Austin (PizzaHi5)

/// @notice Give admin control to a trusted entity for distributing shame coins
/// @custom:experimental This is an experimental contract

contract ShameCoin is ERC20, Ownable {

    /// @dev These are boolean conditions for restricting control of the admin and minting
    mapping(address => bool) public canAdminTransfer;
    mapping(address => bool) public canAdminBurn;
    mapping(address => bool) public isMinting;

    constructor(
    string memory _name, 
    string memory _symbol,
    address _admin)
    ERC20(_name, _symbol) {
        transferOwnership(_admin);
    }

    function decimals() public view virtual override returns(uint8) {
        return 0;
    }

    function allowAdminTransfer() public {
        canAdminTransfer[msg.sender] = true;
    }

    function allowAdminBurn() public {
        canAdminBurn[msg.sender] = true;
    }

    /// @notice Allows owner to mint to any address
    function mint(address target) public onlyOwner {
        isMinting[target] = true;
        _mint(target, 1);
    }

    /// @notice Allows owner to burn to any address if that address owner permits
    function burn(address target) public onlyOwner {
        require(canAdminBurn[target], "Not allowed to burn");
        canAdminBurn[target] = false;
        _burn(target, 1);
    }

    /// @return bool: returns true if transfer succeeded
    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        amount = 1;
        address sender = _msgSender();
        return checkIfOwner(sender) ? super.transfer(to, amount) : super.transfer(sender, amount);
    }

    /// @return bool: returns true if transferFrom succeeded
    function transferFrom(address from, address to, uint256 amount) public virtual override onlyOwner returns (bool) {
        require(canAdminTransfer[from], "Not allowed to transfer");
        canAdminTransfer[from] = false;
        amount = 1;
        return super.transferFrom(from, to, amount);
    }

    /// @dev Mints a token to non-owner transfers
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
        if(!checkIfOwner(msg.sender) && isMinting[to]) {
            isMinting[to] = false;
            _mint(to, amount);
        }
    }

    function checkIfOwner(address sender) internal view returns (bool) {
        return sender == owner() ? true : false;
    }
}