// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTMarketplace is ERC721 {

    event OwnershipTransferred(address owner, address _newOwner);

    error ONLY_OWNER_CAN_MINT();
     error NFT_NOT_FOR_SALE();
    error ONLY_OWNER_CAN_SELL();

    

    address public owner;
    uint256 public tokenId = 1;

    struct NFT {
        address owner;
        uint256 price;
        bool isForSale;
    }

    mapping(uint256 => NFT) public nfts;

    constructor() ERC721(" Daniel NFT Marketplace", "NFTD") {
        owner = msg.sender;
    }

    function mintNFT(address _owner, uint256 _price) external returns (uint256) {

        if(msg.sender != owner){
            revert("ONLY_OWNER_CAN_MINT");

        }
        uint256 newTokenId = tokenId++;
        _safeMint(_owner, newTokenId);
        nfts[newTokenId] = NFT(_owner, _price, false);
        return newTokenId;
    }

    function sellNFT(uint256 _tokenId, uint256 _price) external {
        if(msg.sender != nfts[_tokenId].owner){
            revert("ONLY_OWNER_CAN_SELL");

        }
        require(nfts[_tokenId].isForSale == false, "NFT is already for sale");
        nfts[_tokenId].price = _price;
        nfts[_tokenId].isForSale = true;
    }

    function buyNFT(uint256 _tokenId) external payable {
        if (nfts[_tokenId].isForSale != true){
            revert("NFT_NOT_FOR_SALE");
        }
        require(msg.value >= nfts[_tokenId].price, "Not enough Ether to buy NFT");
        address seller = nfts[_tokenId].owner;
        nfts[_tokenId].isForSale = false;
        nfts[_tokenId].price = 0;
        _transfer(seller, msg.sender, _tokenId);
    }


    function transferOwnership(address _newOwner) external {
        isOwner();
        require(_newOwner != address(0), "Invalid new owner address");
        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }

     function isOwner() private view returns (bool) {
        return msg.sender == owner;
    }
}
