// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./Potion.sol";
import "node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./LibString.sol";   // https://github.com/Vectorized/solady/blob/main/src/utils/LibString.sol

contract Whale is ERC721Enumerable {
    event Minted(address indexed to, uint256 indexed tokenId);
    event Mutated(uint256 indexed whaleTokenId, uint256 indexed potionTokenId);

    address public owner;
    Potion public potionNFTContract;

    uint256 public constant MAX_SUPPLY = 621;
    uint256 public mintPrice;

    bool public mintActive;
    bool public revealActive;

    string private baseURI;
    string private mutatedBaseURI;
    string private notRevealedURI;

    mapping(uint256 => bool) private mutated;
    mapping(address => uint256) public mintedPerAddress;

    constructor(string memory _baseURI, string memory _notRevealedURI) ERC721("Whale", "WHL") {
        owner = msg.sender;
        baseURI = _baseURI;
        notRevealedURI = _notRevealedURI;
        mintActive = false;
        revealActive = false;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
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
            uint256 newTokenId = totalSupply() + 1;
            _safeMint(msg.sender, newTokenId);
            emit Minted(msg.sender, newTokenId);
        }

        if (msg.sender != owner) {
            mintedPerAddress[msg.sender] += amount;
        }
    }

    function mutateWhale(uint256 whaleTokenId, uint256 potionTokenId) external {
        require(ownerOf(whaleTokenId) == msg.sender, "Whale: Must own Whale NFT to mutate");
        require(potionNFTContract.ownerOf(potionTokenId) == msg.sender, "Whale: Must own Potion NFT to mutate");
        require(!mutated[whaleTokenId], "Whale: Already mutated");

        potionNFTContract.burn(potionTokenId);
        mutated[whaleTokenId] = true;
        emit Mutated(whaleTokenId, potionTokenId);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(ownerOf(tokenId) != address(0), "ERC721Metadata: URI query for nonexistent token");

        if (mutated[tokenId]) {
            return string(abi.encodePacked(mutatedBaseURI, LibString.toString(tokenId), ".json"));
        } else if (revealActive) {
            return string(abi.encodePacked(baseURI, LibString.toString(tokenId), ".json"));
        } else {
            return notRevealedURI;
        }
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        (bool success, ) = owner.call{value: balance}("");
        require(success, "Transfer failed");
    }
}