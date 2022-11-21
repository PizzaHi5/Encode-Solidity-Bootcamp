//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ShameCoin is ERC20, Ownable {


    constructor(string memory _name, string memory _symbol)
    ERC20(_name, _symbol) {

    }

    function decimals() public view virtual override returns(uint8) {
        return 0;
    }

    function mint(address target) public onlyOwner {
        _mint(target, 1);
    }

    function burn(address target) public onlyOwner {
        _burn(target, 1);
    }

    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        amount = 1;
        address sender = _msgSender();
        checkIfOwner(sender) ? _transfer(sender, to, amount) : _transfer(sender, sender, amount);
    }

    //This takes advantage of the hooks in ERC20
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
        if(checkIfOwner(from)) {
            _mint(to, amount);
        }
    }

    function checkIfOwner(address sender) internal view returns (bool) {
        return sender == owner() ? true : false;
    }
}