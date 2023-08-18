// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import './ERC721.sol';
import './interfaces/IERC721Enumerable.sol';

/**
 * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
contract ERC721Enumerable is IERC721Enumerable, ERC721{

    uint256[] private _allTokens;

    // mapping from tokenId to position in _alltokens array

    mapping(uint256 => uint256) private _allTokensIndex;


    // mapping of owner to list of all owner token ids

    mapping(address => uint256[]) private _ownedTokens;

    // mapping from token ID index of the owner tokens list

    mapping(uint256 => uint256) private _ownedTokensIndex; 

    constructor() {
        _registerInterface(bytes4(keccak256('totalSupply(bytes4)')^
        keccak256('tokenByIndex(bytes4)')^keccak256('tokenOfOwnerByIndex(bytes4)')));
    }



    /**
     * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
     * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
     */
    //function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);

    /**
     * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
     * Use along with {totalSupply} to enumerate all tokens.
     */
    //function tokenByIndex(uint256 index) external view returns (uint256);

    function _mint(address to,uint256 tokenId) internal override(ERC721) {

        super._mint(to, tokenId);
        // add tokens to the owner
        // add tokens to the total supply

        _addTokensToAllTokenEnumeration(tokenId);
        _addTokensToOwnerEnumeration(to, tokenId);



    }

    function  _addTokensToAllTokenEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] =_allTokens.length;
        _allTokens.push(tokenId);

    }

    function _addTokensToOwnerEnumeration(address to,uint256 tokenId) private {

        //owndeTokenindex tokenId set to address of ownedTokens position
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;

        //add address and tokenId to the _ownedTokens
        _ownedTokens[to].push(tokenId);
        
        //we want to execute the function with minting
    }

    // two functions - one that returns tokenByIndex and 
    // another one that returns tokenByOwnerIndex

    function tokenByIndex(uint256 index) public override view returns(uint256) {
        require(index < _allTokens.length, "global index is out of bounds");
        return _allTokens[index];
            }

    function tokenOfOwnerByIndex(address owner, uint256 index) public override view returns(uint256) {
        require(index < balanceOf(owner), "ownder index is out of bounds");
        return _ownedTokens[owner][index];
    }


     function totalSupply() public override view returns (uint256){
        return _allTokens.length;
    }

}
