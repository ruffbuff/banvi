/*

    ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██
    █                                                            █
    █   RRRRR   U   U  FFFFF  FFFFF  B   B  U   U  FFFFF  FFFFF  █
    █   R   R   U   U  F      F      B   B  U   U  F      F      █
    █   RRRRR   U   U  FFFF   FFFF   BBBBB  U   U  FFFF   FFFF   █
    █   R  R    U   U  F      F      B   B  U   U  F      F      █
    █   R   R   UUUUU  F      F      B   B  UUUUU  F      F      █
    █                                                            █
    ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ██

#Wallet: 0xruffbuff.eth
#Discord: chain.eth | 0xRuffBuff#8817

*/
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract SimpleNFTCollection is ERC721 { // Change smart contract name

    address private _owner;
    uint256 private _tokenIdCounter = 0; // NFT ID counter
    uint256 public constant SUPPLY = 3000; // Change NFTs total supply
    uint256 public mintPrice = 0.05 ether; // Change NFTs mint price

    string private _baseTokenURI;

    modifier onlyOwner() {
        require(msg.sender == _owner, "Not the contract owner");
        _;
    }

    constructor(string memory baseURI) ERC721("SimpleNFTCollection", "SNFT") { // Change SimpleNFTCollection and SNFT
        _baseTokenURI = baseURI; // Set base NFT URI (metadata)
        _owner = msg.sender; // Who deploys contract - set's as Owner
    }

    // Mint NFT by paying mintPrice
    function mint() public payable {
        require(_tokenIdCounter < SUPPLY, "Max supply reached");
        require(msg.value >= mintPrice, "Not enough Ether sent");
        _mint(msg.sender, _tokenIdCounter);
        _tokenIdCounter++;
    }

    // Return base URI
    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    // Only owner can set new base URI
    function setBaseURI(string memory baseURI) external onlyOwner {
        _baseTokenURI = baseURI;
    }

    // Only owner can set new mint price
    function setMintPrice(uint256 newPrice) external onlyOwner {
        mintPrice = newPrice;
    }

    // Only owner can withdraw mint funds from contract
    function withdraw() external onlyOwner {
        payable(_owner).transfer(address(this).balance);
    }
}