// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "base64-sol/base64.sol";

contract DynamicSvgNft is ERC721{
    // mint
    // store our SVG info somewhere
    // Some logic to say "Show X image" or "Show Y image"

    uint256 private s_tokenCounter;
    string private i_lowImageURI;
    string private i_highImageURI;
    string private constant base64EncodedSvgPrefix = "data:image/svg+xml;base64,";

    // Error
    error ERC721Metadata__URI_QueryFor_NonExistentToken();

    constructor(string memory lowSvg, string memory highSvg) ERC721("Dynamic SVG NFT", "DSN") {
        s_tokenCounter = 0;
    }

    function svgToImageURI(string memory svg) public pure returns (string memory) {
        string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg))));
        return string(abi.encodePacked(base64EncodedSvgPrefix, svgBase64Encoded));
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

    // function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
    //     if (!_exists(tokenId)) {
    //         revert ERC721Metadata__URI_QueryFor_NonExistentToken();
    //     }
    //     (, int256 price, , , ) = i_priceFeed.latestRoundData();
    //     string memory imageURI = s_lowImageURI;
    //     if (price >= s_tokenIdToHighValues[tokenId]) {
    //         imageURI = s_highImageURI;
    //     }
    //     return
    //         string(
    //             abi.encodePacked(
    //                 _baseURI(),
    //                 Base64.encode(
    //                     bytes(
    //                         abi.encodePacked(
    //                             '{"name":"',
    //                             name(), // You can add whatever name here
    //                             '", "description":"An NFT that changes based on the Chainlink Feed", ',
    //                             '"attributes": [{"trait_type": "coolness", "value": 100}], "image":"',
    //                             imageURI,
    //                             '"}'
    //                         )
    //                     )
    //                 )
    //             )
    //         );
    // }
}