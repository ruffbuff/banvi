// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./Potion.sol";
import "node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./LibString.sol";   // https://github.com/Vectorized/solady/blob/main/src/utils/LibString.sol

contract Whale is ERC721Enumerable {
    event Minted(address indexed to, uint256 indexed tokenId);
    event Mutated(uint256 indexed whaleTokenId, uint256 indexed potionTokenId);

    address public owner;
    address public bot;
    Potion public potionNFTContract;

    uint256 public constant MAX_SUPPLY = 621;
    uint256 private maxTokenId;
    uint256 public mintPrice;

    bool public mintActive;
    bool public revealActive;

    string private baseURI;
    string private mutatedBaseURI;
    string private notRevealedURI;

    mapping(uint256 => bool) private mutated;
    mapping(uint256 => uint256) public whaleToPotion;
    mapping(address => uint256) public mintedPerAddress;

    constructor(string memory _baseURI, string memory _notRevealedURI) ERC721("Whale", "WHL") {
        owner = msg.sender;
        bot = msg.sender;
        baseURI = _baseURI;
        notRevealedURI = _notRevealedURI;
        mintActive = false;
        revealActive = false;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    modifier onlyBot() {
        require(msg.sender == bot, "Not the bot");
        _;
    }

    function setPotionDetails(address _potionAddress, string memory _mutatedBaseURI) external onlyOwner {
        potionNFTContract = Potion(_potionAddress);
        mutatedBaseURI = _mutatedBaseURI;
    }

    function setMintPrice(uint256 _newPrice) public onlyOwner {
        mintPrice = _newPrice;
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function setNotRevealedURI(string memory _newNotRevealedURI) public onlyOwner {
        notRevealedURI = _newNotRevealedURI;
    }

    function setBot(address _newBot) public onlyOwner {
        bot = _newBot;
    }

    function isMutated(uint256 tokenId) public view returns (bool) {
        return mutated[tokenId];
    }

    function toggleMintActive() public onlyOwner {
        mintActive = !mintActive;
    }

    function toggleRevealActive() public onlyOwner {
        revealActive = !revealActive;
    }

    function mint(uint256 amount) public payable {
        require(mintActive, "Minting is not active");
        require(totalSupply() + amount <= MAX_SUPPLY, "Exceeds maximum supply");

        if (msg.sender != owner) {
            require(mintedPerAddress[msg.sender] + amount <= 5, "Exceeds allowed mint amount per address");
            require(msg.value >= mintPrice * amount, "Insufficient funds");
        }

        for (uint256 i = 0; i < amount; i++) {
            maxTokenId++;
            _safeMint(msg.sender, maxTokenId);
            emit Minted(msg.sender, maxTokenId);
        }

        if (msg.sender != owner) {
            mintedPerAddress[msg.sender] += amount;
        }
    }

    function mutateWhale(uint256 whaleTokenId, uint256 potionTokenId) external {
        require(whaleTokenId > 5, "Whale: Cannot mutate the first 5 NFTs");
        require(ownerOf(whaleTokenId) == msg.sender, "Whale: Must own Whale NFT to mutate");
        require(potionNFTContract.ownerOf(potionTokenId) == msg.sender, "Whale: Must own Potion NFT to mutate");
        require(!mutated[whaleTokenId], "Whale: Already mutated");

        mutated[whaleTokenId] = true;
        whaleToPotion[whaleTokenId] = potionTokenId;
        potionNFTContract.burn(potionTokenId);

        emit Mutated(whaleTokenId, potionTokenId);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(ownerOf(tokenId) != address(0), "ERC721Metadata: URI query for nonexistent token");

        if (mutated[tokenId]) {
            return string(abi.encodePacked(mutatedBaseURI, LibString.toString(tokenId), ".json"));
        } else if (revealActive) {
            return string(abi.encodePacked(baseURI, LibString.toString(tokenId), ".json"));
        } else {
            return string(abi.encodePacked(notRevealedURI, LibString.toString(tokenId), ".json"));
        }
    }

    function changeTokenURI(uint256 tokenId, string memory newBaseURI) public onlyBot {
        require(ownerOf(tokenId) != address(0), "ERC721Metadata: URI query for nonexistent token");

        if (mutated[tokenId]) {
            mutatedBaseURI = newBaseURI;
        }
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        (bool success, ) = owner.call{value: balance}("");
        require(success, "Transfer failed");
    }
}