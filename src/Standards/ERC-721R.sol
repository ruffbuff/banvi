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

import "node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract SimpleNFTCollection is ERC721Enumerable {
    address payable private _owner;
    uint256 private _tokenIdCounter = 0;
    uint256 public constant SUPPLY = 3000;
    uint256 public mintPrice = 0.05 ether;

    string private _baseTokenURI;

    modifier onlyOwner() {
        require(msg.sender == _owner, "Not the contract owner");
        _;
    }

    constructor(string memory baseURI) ERC721("SimpleNFTCollection", "SNFT") {
        _baseTokenURI = baseURI;
        _owner = payable(msg.sender);
    }

    function mint() public payable {
        require(_tokenIdCounter < SUPPLY, "Max supply reached");
        require(msg.value >= mintPrice, "Not enough Ether sent");
        _mint(msg.sender, _tokenIdCounter);
        _tokenIdCounter++;
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    function setBaseURI(string memory baseURI) external onlyOwner {
        _baseTokenURI = baseURI;
    }

    function setMintPrice(uint256 newPrice) external onlyOwner {
        mintPrice = newPrice;
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");

        (bool sent, ) = _owner.call{value: balance}("");
        require(sent, "Failed to send Ether");
    }
}