// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./Whale.sol";
import "node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./LibString.sol";   // https://github.com/Vectorized/solady/blob/main/src/utils/LibString.sol

contract Potion is ERC721Enumerable {
    event Mint(address indexed to, uint256 amount);

    enum MintStage { CLOSED, STAGE1, STAGE2, OPEN }
    MintStage public currentStage = MintStage.CLOSED;

    address public owner;
    Whale public whaleNFTContract;

    uint256 public constant MAX_SUPPLY = 470;
    uint256 private maxTokenId;
    
    string private baseURI;

    mapping(address => bool) public mystery;
    mapping(address => bool) public whitelist;
    mapping(address => uint256) public mintedAmount;

    constructor(string memory _baseURI) ERC721("Potion", "POT") {
        owner = msg.sender;
        baseURI = _baseURI;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    function setBaseURI(string memory newBaseURI) external onlyOwner {
        baseURI = newBaseURI;
    }

    function setWhaleContractAddress(address _whaleAddress) external onlyOwner {
        whaleNFTContract = Whale(_whaleAddress);
    }

    function updateStage(MintStage _stage) external onlyOwner {
        currentStage = _stage;
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
            _mintSave(msg.sender, amount);
        } else {
            require(mintedAmount[msg.sender] + amount <= getMaxMints(msg.sender), "Exceeds allowed mint amount");
            mintedAmount[msg.sender] += amount;
            _mintSave(msg.sender, amount);
        }
    }

    function _mintSave(address to, uint256 amount) internal {
        for (uint256 i = 0; i < amount; i++) {
            maxTokenId++;
            _safeMint(to, maxTokenId);
        }
        emit Mint(to, amount);
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

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(ownerOf(tokenId) != address(0), "ERC721Metadata: URI query for nonexistent token");
        return string(abi.encodePacked(baseURI, LibString.toString(tokenId), ".json"));
    }

    function burn(uint256 tokenId) public {
        require(ownerOf(tokenId) == msg.sender || getApproved(tokenId) == msg.sender, "Potion: caller is not owner nor approved");
        _burn(tokenId);
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        (bool success, ) = owner.call{value: balance}("");
        require(success, "Transfer failed");
    }
}