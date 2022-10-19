// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

error nftStakeTest__NeedMoreETHSent();

contract nftStakeTest is ERC721, Ownable, ERC721URIStorage {
    uint256 public mintPrice;
    using Counters for Counters.Counter;
    Counters.Counter public _tokenIdCounter;
    string public baseUrl = "https://www.test.com/";

    constructor() ERC721("NFT Stake", "NSK") {
        mintPrice = 0.02 ether;
    }

    function mint() public payable {
        if (msg.value < mintPrice) {
            revert nftStakeTest__NeedMoreETHSent();
        }
        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();
        _safeMint(msg.sender, tokenId);
        _setTokenURI(
            tokenId,
            string.concat(baseUrl, Strings.toString(tokenId))
        );
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    // withdraw function for withdrawing funds
    function withdraw() public onlyOwner {
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call failed");
    }

    // fall back function
    receive() external payable {}
}
