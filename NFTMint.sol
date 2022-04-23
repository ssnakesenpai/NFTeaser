// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

//import "@openzeppelin/contracts@4.5.0/token/ERC721/ERC721.sol";
//import "@openzeppelin/contracts@4.5.0/access/Ownable.sol";

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract MyToken is ERC721 {
    constructor() ERC721("MyToken", "MTK") {}

    function safeMint(address to, uint256 tokenId) public  {
        _safeMint(to, tokenId);
    }
}
