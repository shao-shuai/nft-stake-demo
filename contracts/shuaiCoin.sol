// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";

error Shuaicoin_NotTokenOwner();
error Shuaicoin_ContractClosed();

contract Shuaicoin is ERC20, Ownable, ERC721Holder {
    address public nftAddress;
    mapping(uint256 => address) public tokenIdToOwner;
    mapping(uint256 => uint256) public tokenToTime;
    bool private _status;

    constructor(bool status, address _nftAddress) ERC20("Shuai Coin", "SC") {
        _status = status;
        nftAddress = _nftAddress;
    }

    function stake(uint256 tokenId) public {
        if (_status = false) {
            revert Shuaicoin_ContractClosed();
        }
        IERC721 nft = IERC721(nftAddress);
        nft.safeTransferFrom(_msgSender(), address(this), tokenId);
        // here user can only stake one token
        tokenIdToOwner[tokenId] = _msgSender();
        tokenToTime[tokenId] = block.timestamp;
    }

    function unstake(uint256 tokenId) public {
        if (tokenIdToOwner[tokenId] != _msgSender()) {
            revert Shuaicoin_NotTokenOwner();
        }
        if (tokenIdToOwner[tokenId] != _msgSender()) {
            revert Shuaicoin_NotTokenOwner();
        }
        IERC721 nft = IERC721(nftAddress);
        nft.safeTransferFrom(address(this), _msgSender(), tokenId);
        tokenIdToOwner[tokenId] = address(0);
        _mint(
            _msgSender(),
            (block.timestamp - tokenToTime[tokenId]) * 10**decimals()
        );
        tokenToTime[tokenId] = 0;
    }

    function updateStatus(bool status) public onlyOwner {
        _status = status;
    }
}
