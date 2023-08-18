// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//import './interfaces/IERC165.sol';
import './ERC165.sol';
import './interfaces/IERC721.sol';
import './Libraries/Counters.sol';

contract ERC721 is ERC165, IERC721 {
    // mapping from token id to the owner

   
    mapping(uint256 => address) private _tokenOwner;

    // mapping from owner to number of owned tokens;

    mapping(address => uint256) private _OwnedTokenCount;

    mapping(uint256 => address) private _tokenApprovals;

    constructor() {
        _registerInterface(bytes4(keccak256('balanceOf(bytes4)')^
        keccak256('ownerOf(bytes4)')^keccak256('transferFrom(bytes4)')));
    }


    function balanceOf(address _owner) override public view returns(uint256) {
        require(_owner != address(0), "owner query for non existent token");

        return _OwnedTokenCount[_owner];
    }

    function ownerOf(uint256 _tokenId) override public view returns(address) {
         address owner = _tokenOwner[_tokenId];
         require(owner != address(0),"owner query for non-existent");
         return owner;
    }

    function _exists(uint256 tokenId) internal view returns(bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

    function _mint(address to, uint tokenId) internal virtual {
        require(to != address(0), "invalid adddress");

        // token doesnot already exist
        require(!_exists(tokenId),'ERC721 token is already minted');
        _tokenOwner[tokenId] = to;
        //_OwnedTokenCount[to]++;
        _OwnedTokenCount[to] = _OwnedTokenCount[to] + 1;
        //OwnerTokenCount[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }

    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
        require(_to != address(0),"Not possible you cant send to zero addeess");
        require(ownerOf(_tokenId) == _from, "trying to tranfer token the address does not own");
        // update the balance of the address _from token
        _OwnedTokenCount[_from] -= 1;

        // update the balance of the address _from token
         _OwnedTokenCount[_to] += 1;

         // add the tokenId to the address receving the token
        _tokenOwner[_tokenId] = _to ;

        emit Transfer(_from, _to, _tokenId);

    }

    function transferFrom(address _from, address _to, uint256 _tokenId)override public {
        require(isApprovedOrOwner(msg.sender, _tokenId));
        _transferFrom(_from, _to, _tokenId);
    }

    function approve(address _to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(_to != owner,'error-approval to current owner');
        require(msg.sender == owner, "current caller is not the owner of token");

        _tokenApprovals[tokenId] = _to;

        emit Approval(owner, _to, tokenId);
    }

    function isApprovedOrOwner(address spender, uint256 tokenId) internal view returns(bool) {
        require(_exists(tokenId), "token does not exist");
        address owner = ownerOf(tokenId);
        return (spender == owner);

    }


}