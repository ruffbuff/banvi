// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IERC721 {
    function ownerOf(uint256 tokenId) external view returns (address owner);
    function transferFrom(address from, address to, uint256 tokenId) external;
    function approve(address to, uint256 tokenId) external;
    function getApproved(uint256 tokenId) external view returns (address operator);
}

contract Merge {
    event Claimed(address claimer, uint256 oldNFTCount, uint256 newNFTCount);
    
    address public oldNFTAddress;
    address public newNFTAddress;
    address private owner;
    address private constant DEAD_ADDRESS = 0x000000000000000000000000000000000000dEaD;

    mapping(address => bool) public hasClaimed;
    
    uint256[] private availableNewNFTs;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    function addAvailableNewNFTs(uint256[] calldata tokenIds) external onlyOwner {
        for (uint i = 0; i < tokenIds.length; i++) {
            bool isAlreadyAdded = false;
            for (uint j = 0; j < availableNewNFTs.length; j++) {
                if (availableNewNFTs[j] == tokenIds[i]) {
                    isAlreadyAdded = true;
                    break;
                }
            }
            if (!isAlreadyAdded) {
                availableNewNFTs.push(tokenIds[i]);
            }
        }
    }

    function claim(uint256[] calldata oldTokenIds) external {
        require(!hasClaimed[msg.sender], "Already claimed");
        require(oldTokenIds.length > 0, "Must submit at least one old NFT");
        uint256 newNFTsToClaim = calculateNewNFTs(oldTokenIds.length);
        require(availableNewNFTs.length >= newNFTsToClaim, "Not enough new NFTs in contract");

        for (uint i = 0; i < oldTokenIds.length; i++) {
            require(IERC721(oldNFTAddress).ownerOf(oldTokenIds[i]) == msg.sender, "Caller does not own the old NFT");
            IERC721(oldNFTAddress).transferFrom(msg.sender, DEAD_ADDRESS, oldTokenIds[i]);
        }

        uint256[] memory claimedNFTs = new uint256[](newNFTsToClaim);
        for (uint i = 0; i < newNFTsToClaim; i++) {
            claimedNFTs[i] = availableNewNFTs[i];
            IERC721(newNFTAddress).transferFrom(address(this), msg.sender, claimedNFTs[i]);
        }

        for (uint i = 0; i < newNFTsToClaim; i++) {
            for (uint j = 0; j < availableNewNFTs.length; j++) {
                if (availableNewNFTs[j] == claimedNFTs[i]) {
                    availableNewNFTs[j] = availableNewNFTs[availableNewNFTs.length - 1];
                    availableNewNFTs.pop();
                    break;
                }
            }
        }

        hasClaimed[msg.sender] = true;
        emit Claimed(msg.sender, oldTokenIds.length, newNFTsToClaim);
    }

    function withdrawNFT(uint256 tokenId) external onlyOwner {
        for (uint i = 0; i < availableNewNFTs.length; i++) {
            if (availableNewNFTs[i] == tokenId) {
                availableNewNFTs[i] = availableNewNFTs[availableNewNFTs.length - 1];
                availableNewNFTs.pop();
                break;
            }
        }

        IERC721(newNFTAddress).transferFrom(address(this), owner, tokenId);
    }


    function updateOldNFTAddress(address _newOldNFTAddress) external onlyOwner {
        require(_newOldNFTAddress != address(0), "Invalid address");
        oldNFTAddress = _newOldNFTAddress;
    }

    function updateNewNFTAddress(address _newNewNFTAddress) external onlyOwner {
        require(_newNewNFTAddress != address(0), "Invalid address");
        newNFTAddress = _newNewNFTAddress;
    }

    function getAvailableNewNFTs() public view returns (uint256[] memory) {
        return availableNewNFTs;
    }

    function calculateNewNFTs(uint256 oldNFTCount) private pure returns (uint256) {
        if (oldNFTCount >= 6) {
            return 3;
        } else if (oldNFTCount >= 3) {
            return 2;
        } else {
            return 1;
        }
    }
}