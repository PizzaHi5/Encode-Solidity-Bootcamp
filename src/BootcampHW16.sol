//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@base64/base64.sol";
//use import "base64-sol/base64.sol"; for remix
import "@openzeppelin/contracts/utils/Counters.sol";

contract VolcanoNFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenId;

    constructor(string memory _name, string memory _symbol)
    ERC721(_name, _symbol) {

    }

    function mintAFeesh() public {
        uint newItemId = _tokenId.current();
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI(newItemId));
        _tokenId.increment();
    }

    //This will allow us to custom edit the tokenURI view function in ERC721
    // , in white used to input variables, else apart of metadata
    function _baseURI() internal pure override returns (string memory) {
        return Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
        '{'
           '"description": "The poggest feesh around",'
           '"external_url": "ipfs://bafkreiclzbzmykzlig56d6qwfpihwlsgr4dxx34i3fcpd7fbthgzba3454",'
           '"image_url": "https://bafkreiclzbzmykzlig56d6qwfpihwlsgr4dxx34i3fcpd7fbthgzba3454.ipfs.nftstorage.link/",'
           '"cid": "bafkreiclzbzmykzlig56d6qwfpihwlsgr4dxx34i3fcpd7fbthgzba3454",'
           '"name": "NemuPog",'
           '"attributes": ['
                '{'
                '"trait_type": "Topness",' 
                '"value": "10"'
                '},' 
                '{'
                '"trait_type": "Personality",' 
                '"value": "Tomboy"'
                '},' 
                '{'
                '"trait_type": "Animal",' 
                '"value": "Feesh"'
                '},' 
                '{'
                '"trait_type": "Poggness",' 
                '"value": "9"'
                '}'
            ']'
        '}'
        ))));
    }

}