// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import "@solmate/src/auth/Owned.sol";

contract Spoke is Owned {
    address public hub;
    uint256 public immutable tokenId;

    modifier onlyHub() virtual {
        require(msg.sender == hub);
        _;
    }

    constructor(address _owner, uint256 _tokenId) Owned(_owner) {
        tokenId = _tokenId;
        hub = msg.sender;
    }

    function setOwner(address newOwner) public virtual onlyHub {
        owner = newOwner;
        emit OwnershipTransferred(msg.sender, newOwner);
    }
}