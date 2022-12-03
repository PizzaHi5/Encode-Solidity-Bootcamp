// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@solmate/src/tokens/ERC721.sol";
import "@solmate/src/auth/Owned.sol";
import "./Canvas.sol";

interface IERC721 {
    function ownerOf(uint256 id) external view returns (address owner);
}

contract CanvasFactory is ERC721, Owned {
    uint256 public constant MAX_SUPPLY = 2048;
    uint256 public constant PRICE = .02 ether;

    uint256 public totalSupply;

    mapping(uint256 => address) public canvases;

    constructor() ERC721("Canvas", "CAN") Owned(msg.sender) {}

    // ERC721 Functionality
    // Most non-view functions will have two cases - one where the caller is an EOA, and another
    // where the caller is the standalone canvas

    // Events: Transfer, Approval, ApprovalForAll - emitted from hub contract
    // ERC721 Functions:
    // balanceOf(address _owner) external view returns (uint256);
    // ownerOf(uint256 _tokenId) external view returns (address);
    // safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable;
    // safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
    // transferFrom(address _from, address _to, uint256 _tokenId) external payable;
    // approve(address _approved, uint256 _tokenId) external payable;
    // setApprovalForAll(address _operator, bool _approved) external;
    // getApproved(uint256 _tokenId) external view returns (address);
    // isApprovedForAll(address _owner, address _operator) external view returns (bool);

    // ERC721Metadata functions: tokenURI, name, symbol

    /* View functions */
    function ownerOf(uint256 _tokenId) public view virtual override returns (address) {
        return Canvas(canvases[_tokenId]).ownerOf(); // will correctly throw if token doesn't exist
    }

    function tokenURI(uint256 id) public view virtual override returns (string memory) {
        require(canvases[id] != address(0), "DOES_NOT_EXIST");
        return Canvas(canvases[id]).tokenURI();
    }
    
    function balanceOf(address owner) public view virtual override returns (uint256) {
        super.balanceOf(owner);
    }

    /* Approvals */
    function approve(address _approved, uint256 _tokenId) public virtual override {
        // Can skip this require if msg.sender is the canvas, already handle
        // authorizations there
        if (msg.sender != canvases[_tokenId]) {
            require(isAuthorized(msg.sender, _tokenId), "NOT_AUTHORIZED");
        }
        getApproved[_tokenId] = _approved;
    }

    // Would prefer to not do this but only other way I can think of is using tx.origin?
    function setApprovalForAll(
        address operator,
        bool approved
    ) public virtual override {
        //require(fromCanvas(_tokenId), "NOT_AUTHORIZED");
        super.setApprovalForAll(operator, approved);
    }

    function transferFrom(address from, address to, uint256 id) public virtual override {
        super.transferFrom(from, to, id);
    }
    function safeTransferFrom(address from, address to, uint256 id) public virtual override {
        super.safeTransferFrom(from, to, id);
    }

    function safeTransferFrom(address from, address to, uint256 id, bytes calldata data) public virtual override {
        super.safeTransferFrom(from, to, id, data);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override returns(bool) {
        super.supportsInterface(interfaceId);
    }

    /* Minting Logic */
    function mintWithEth() external payable {
        require(msg.value == PRICE, "NOT_ENOUGH_ETH");
        cutCanvas();
    }

    // Removing address(0) checks from solmate ERC721
    function _mint(address to, uint256 id) internal virtual override {
        cutCanvas();
    }

    // Mint
    function cutCanvas() internal {
        uint id = ++totalSupply;
        require(id < MAX_SUPPLY, "OUT_OF_STOCK");
        address newCanvas = address(new Canvas(msg.sender, id));
        canvases[id] = newCanvas;
        super._mint(msg.sender, id);
    }

    function _burn(uint256 id) internal virtual override {
        super._burn(id);
    }

    // Helpers
    function isContract(address addr) internal view returns (bool) {
        uint size;
        assembly {
            size := extcodesize(addr)
        }
        return size > 0;
    }

    function isAuthorized(
        address _operator,
        uint256 _tokenId
    ) internal view returns (bool) {
        address _owner = _ownerOf[_tokenId];
        return (_owner == _operator ||
            isApprovedForAll[_owner][_operator] == true ||
            getApproved[_tokenId] == _operator);
    }

    function fromCanvas(uint256 _tokenId) internal view returns (bool) {
        return (msg.sender == canvases[_tokenId]);
    }
}
/* Duplicate implementation of ERC721
abstract contract ERC721TokenReceiver {
    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external virtual returns (bytes4) {
        return ERC721TokenReceiver.onERC721Received.selector;
    }
}*/