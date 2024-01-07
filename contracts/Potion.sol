// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./Whale.sol";
import "node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./LibString.sol";   // https://github.com/Vectorized/solady/blob/main/src/utils/LibString.sol

contract Potion is ERC721Enumerable {
    event MintMultiple(address indexed to, uint256 amount);

    enum MintStage { CLOSED, STAGE1, STAGE2, OPEN }
    MintStage public currentStage = MintStage.CLOSED;

    address public owner;
    Whale public whaleNFTContract;

    uint256 public constant MAX_SUPPLY = 466;

    string private baseURI;
    string private revealedBaseURI;

    bool public isRevealed = false;

    mapping(address => bool) public mystery;
    mapping(address => bool) public whitelist;
    mapping(address => uint256) public mintedAmount;

    constructor(string memory _baseURI, string memory _revealedBaseURI) ERC721("Potion", "POT") {
        owner = msg.sender;
        baseURI = _baseURI;
        revealedBaseURI = _revealedBaseURI;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    function setWhaleContractAddress(address _whaleAddress) external onlyOwner {
        whaleNFTContract = Whale(_whaleAddress);
    }

    function updateStage(MintStage _stage) external onlyOwner {
        currentStage = _stage;
    }

    function setReveal(bool _isRevealed) external onlyOwner {
        isRevealed = _isRevealed;
    }

    function addToMystery(address[] calldata addresses) external onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) {
            mystery[addresses[i]] = true;
        }
    }

    function addToWhitelist(address[] calldata addresses) external onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) {
            whitelist[addresses[i]] = true;
        }
    }

    function mint(uint256 amount) public {
        require(currentStage != MintStage.CLOSED, "Minting is closed");
        require(totalSupply() + amount <= MAX_SUPPLY, "Exceeds maximum supply");

        if (msg.sender == owner) {
            _mintMultiple(msg.sender, amount);
        } else {
            require(mintedAmount[msg.sender] + amount <= getMaxMints(msg.sender), "Exceeds allowed mint amount");
            mintedAmount[msg.sender] += amount;
            _mintMultiple(msg.sender, amount);
        }
    }

    function getMaxMints(address minter) internal view returns (uint256) {
        if (currentStage == MintStage.STAGE1 && mystery[minter]) {
            return 2;
        } else if (currentStage == MintStage.STAGE2 && (whitelist[minter] || mystery[minter])) {
            return 1;
        } else if (currentStage == MintStage.OPEN) {
            return 1;
        }
        return 0;
    }

    function _mintMultiple(address to, uint256 amount) internal {
        for (uint256 i = 0; i < amount; i++) {
            uint256 newTokenId = totalSupply() + 1;
            _safeMint(to, newTokenId + i);
        }
        emit MintMultiple(to, amount);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(ownerOf(tokenId) != address(0), "ERC721Metadata: URI query for nonexistent token");
        if (isRevealed) {
            return string(abi.encodePacked(revealedBaseURI, LibString.toString(tokenId), ".json"));
        } else {
            return baseURI;
        }
    }

    function burn(uint256 tokenId) public {
        require(ownerOf(tokenId) == msg.sender || getApproved(tokenId) == msg.sender, "Potion: caller is not owner nor approved");
        _burn(tokenId);
    }
}