// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Metadata.sol'; // . means it is in same diroctory
//import './ERC721.sol';
import './ERC721Enumerable.sol';

contract ERC721Connector is ERC721Metadata, ERC721Enumerable {

    // we deploy connector right away
    // we want to carry the metadata info overf

    constructor (string memory name, string memory symbol) ERC721Metadata(name, symbol) {
        
        
    }

}