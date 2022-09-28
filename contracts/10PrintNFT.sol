// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;

// import OpenZeppelin contracts
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
// import Base64 library for encoding/decoding
import { Base64 } from "./libraries/Base64.sol";
// import Hardhat console
import "hardhat/console.sol";


contract TenPrintNFT is ERC721URIStorage { // inherit contract we imported (and assoc. methods)
    uint256 private seed; // for pseudo random generator
    uint256 private randomCalls; // for pseudo random generator
    uint256 private canvasWidth = 300; // width of NFT canvas in pixels
    uint256 private canvasHeight = 300; // height of NFT canvas in pixels
    uint256 private spacing = 20; // spacing between slashes in pixels
    uint256 private maxMintCount = 100; // maximum number of NFTs that can be minted (noting count starts at zero)

    using Counters for Counters.Counter; // OpenZeppelin way to track tokenIds
    Counters.Counter private _tokenIds;

    event New10PrintNFTMinted(address sender, uint256 tokenId);

    constructor() ERC721 ("10PrintNFT", "TPNT") { // pass name of NFT token and symbol
        seed = (block.timestamp + block.difficulty) % 100; // generate initial seed
        console.log("10 Print NFT contract successfully compiled!");
    }

    function getTotalNFTsMinted() public view returns (uint256) {
        return _tokenIds.current();
    }

    function mint10PrintNFT() public { // function to mint NFT
        console.log("\n----------------------------");
        console.log("Generating and minting new 10Print NFT...");

        uint256 newItemId = _tokenIds.current(); // get current tokenId. Starts at 0
        require(newItemId < maxMintCount, "Maximum number of NFTs have been minted.");

        string memory finalTokenUri = createSVG(newItemId);
        
        _safeMint(msg.sender, newItemId); // Mint NFT to sender using msg.sender
        _setTokenURI(newItemId, finalTokenUri); // Set the NFT data
        _tokenIds.increment(); // Increment the counter for when the next NFT is minted
        console.log("An NFT w/ ID %s has been minted to %s.", newItemId, msg.sender);
        //console.log("An NFT w/ ID %s has been minted to %s with token URI:", newItemId, msg.sender);
        //console.log(finalTokenUri);
        //console.log("----------------------------\n");

        emit New10PrintNFTMinted(msg.sender, newItemId);
    }

    function createSVG(uint256 newItemId) private returns (string memory) { // function to create SVG
        string memory startSvg = selectStyle();
        string memory middleSvg = createLines();
        string memory endSvg = "</svg>";

        string memory finalSvg = string(abi.encodePacked(startSvg, middleSvg, endSvg));

        // Get all the JSON metadata together and base64 encode it
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "#',
                        // We set the title of our NFT as the item ID.
                        Strings.toString(newItemId),
                        '", "description": "A generative artwork NFT inspired by 10 PRINT CHR$(205.5+RND(1)); : GOTO 10, the one-line Commodore 64 BASIC program.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'

                    )
                )
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
        return finalTokenUri;
    }

    function createLines() private returns (string memory) {
        uint256 x;
        uint256 y;
        string memory currentLine;
        string memory allLines;

        // random weight for proportion of forward to back slashes
        uint256 weight = random();

        // draw NFT
        while (y < canvasHeight) {

            // draw forward or back slash based on weight
            if (random() < weight) {
                currentLine = string(abi.encodePacked("<line x1='",Strings.toString(x),"' x2='",Strings.toString(x+spacing),"' y1='",Strings.toString(y),"' y2='",Strings.toString(y+spacing),"' />"));
            } else {
                currentLine = string(abi.encodePacked("<line x1='",Strings.toString(x),"' x2='",Strings.toString(x+spacing),"' y1='",Strings.toString(y+spacing),"' y2='",Strings.toString(y),"' />"));
            }
            allLines = string(abi.encodePacked(allLines,currentLine));

            // iterate to next x y coordinate for next slash
            x = x + spacing;
            if (x > canvasWidth) {
                x = 0;
                y = y + spacing;
            }
        }
        return string(allLines);
    }

    function selectStyle() private returns (string memory) { // select style and finalize SVG string
        string memory strokeColor;
        string memory strokeWidth = string(abi.encodePacked("stroke-width:", Strings.toString((random() % 6) + 1), ";' "));
        string memory svgMiddle = "width='300' height='300' viewBox='0 0 300 300' xmlns='http://www.w3.org/2000/svg'><rect x='0' y='0' width='300' height='300' stroke='grey' stroke-width='2' ";
        string memory fill;
        uint256 styleSeed = random();
        console.log("Style seed is %s", styleSeed);

        if (styleSeed < 25) {
            strokeColor = "<svg style='stroke:black; ";
            fill = "fill='white' />";
        } else if (styleSeed < 50) {
            strokeColor = "<svg style='stroke:#fefefe; ";
            fill = "fill='#0182c8' />";
        } else if (styleSeed < 75) {
            strokeColor = "<svg style='stroke:#1AE592; ";
            fill = "fill='#E51A6D' />";
        } else {
            strokeColor = "<svg style='stroke:#EDD312; ";
            fill = "fill='#122CED' />";
        }

        return string(abi.encodePacked(strokeColor, strokeWidth, svgMiddle, fill));
    }

    function random() private returns (uint256) { // psuedo-random function
        randomCalls = randomCalls + 1;
        seed = (seed + randomCalls + block.difficulty + block.timestamp) % 100;
        return uint256(seed);
    }
}






