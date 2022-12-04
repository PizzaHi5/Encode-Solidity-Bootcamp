// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@solmate/src/tokens/ERC721.sol";
import "@solmate/src/auth/Owned.sol";

contract BlankCanvas is ERC721, Owned(msg.sender) {
    constructor(string memory _name, string memory _symbol)
    ERC721(_name, _symbol)
    {}

    function tokenURI(uint256 id) public view virtual override returns (string memory) {
        //put custom specifications all final canvases should adhere to
    }    
}