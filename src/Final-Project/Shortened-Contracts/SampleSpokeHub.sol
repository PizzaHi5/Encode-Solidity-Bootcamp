// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./ERC721Hub.sol";
import "./ETFERC20.sol";

interface ISampleSpoke {
    function tokenURI() external view returns (string memory);
}

// Sample ERC721Hub implementation. This is a simple implementation that has
// basic mint logic and inherits from ERC721Hub. The spoke is a SampleSpoke
// with bare-bones tokenURI logic.
contract SampleERC721Hub is ERC721Hub {
    uint256 public constant MAX_SUPPLY = 2048;
    uint256 public constant PRICE = .02 ether;

    uint256 public totalSupply;
    address calcNav;

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721Hub(_name, _symbol) {}

    /* Minting Logic */
    function mintWithEth(address _calcNav) external payable {
        uint256 id = ++totalSupply;
        require(msg.value == PRICE, "NOT_ENOUGH_ETH");
        require(id < MAX_SUPPLY, "OUT_OF_STOCK");
        calcNav = _calcNav;
        _mint(msg.sender, id);
    }

    // Create a new SampleSpoke contract and store the address in the spokes mapping
    function _mint(address to, uint256 id) internal virtual override {
        super._mint(to, id);
        //specific implementation of spoke, change later
        spokes[id] = address(new ETFERC20{value: msg.value}(
            "StarterETF",
            "ETF",
            18,
            1,
            id,
            msg.sender,
            calcNav
        ));
    }

    // In this implementation, we get the tokenURI from the spoke. Up to the dev
    // to determine how they want to handle this in their implementation.
    function tokenURI(uint256 id) public view override returns (string memory) {
        require(spokes[id] != address(0), "DOES_NOT_EXIST");
        return ISampleSpoke(spokes[id]).tokenURI();
    }
}