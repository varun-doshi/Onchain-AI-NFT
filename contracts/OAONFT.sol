// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

interface IOAO{
     function calculateAIResult(uint256 modelId, string calldata prompt) external;
     function getAIResult(uint256 modelId, string calldata prompt) external view returns (string memory);
}

contract OAONFT is ERC721, ERC721URIStorage{
    address iOao;    uint256 private _nextTokenId;
    string constant ipfsPrepend="https://ipfs.io/ipfs/";

    event ONFTMinted(address owner,uint256 tokenId,string tokenURI);

    constructor(address _iOao)
        ERC721("OAONFT", "ONFT"){
        iOao=_iOao;
    }

    function createArt(string memory prompt) public{
        IOAO(iOao).calculateAIResult(1,prompt);
    }
    
    function fetchIpfsHash(string memory prompt) public view returns(string memory){
         string memory ipfsHash = IOAO(iOao).getAIResult(1,prompt);
         return ipfsHash;
    }

    function safeMint(string memory prompt) public{


        bytes memory uri = abi.encodePacked(ipfsPrepend,fetchIpfsHash(prompt));
      

        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, string(uri));
        tokenId++;

        emit ONFTMinted(msg.sender,tokenId,string(uri));
    }


  function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}