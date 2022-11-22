//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ShameCoin is ERC20, Ownable {

    mapping(address => bool) private canAdminTransfer;
    mapping(address => bool) private canAdminBurn;

    //Put a mempool tracker as admin that mints ShameCoins to
    //sandwich/frontrunners/backrunners ;)
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

    function mint(address target) public onlyOwner {
        _mint(target, 1);
    }

    function burn(address target) public onlyOwner {
        require(canAdminBurn[target], "Not allowed to burn");
        canAdminBurn[target] = false;
        _burn(target, 1);
    }

    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        amount = 1;
        address sender = _msgSender();
        return checkIfOwner(sender) ? super.transfer(to, amount) : super.transfer(sender, amount);
    }

    function transferFrom(address from, address to, uint256 amount) public virtual override onlyOwner returns (bool) {
        require(canAdminTransfer[from], "Not allowed to transfer");
        canAdminTransfer[from] = false;
        amount = 1;
        return super.transferFrom(from, to, amount);
    }

    //This takes advantage of the hooks in ERC20
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
        if(!checkIfOwner(from)) {
            _mint(to, amount);
        }
    }

    function checkIfOwner(address sender) internal view returns (bool) {
        return sender == owner() ? true : false;
    }
}