// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "./BlankCanvas.sol";
import "./Paywall.sol";
import "./PixelArt.sol";

/// @notice The completed canvas :)    The Code Art!!

/// @dev Inherit your implementation below!
contract CodeArt is 
BlankCanvas, 
Paywall, 
PixelArt
{
    /// @dev Edit the constructor to fit your needs
    constructor(string memory _name, string memory _symbol)
    BlankCanvas(_name, _symbol)
    {}

    /**
        @dev Add onlyOwner accessible functions below, make implementation in inherited contract
     */

    function SetPixels(uint8[2304] calldata _pixels) external virtual onlyOwner {
        super._setPixels(_pixels);
    }

    function SetPixelsAssembly() external virtual onlyOwner {
        super._setPixelsAssembly();
    }

    function SetPixelsAssembly2() external virtual onlyOwner {
        super._setPixelsAssembly2();
    }

    function SetPixels2(uint8[2304] calldata _pixels) external virtual onlyOwner {
        super._setPixels2(_pixels);
    }

    /// @dev Final NFT Art, overrides BlankCanvas customizations
    function tokenURI(uint256 id) public view override returns (string memory) {
        return super.tokenURI(id);
    }   
}