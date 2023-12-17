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
import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract SimpleToken is ERC20 {
    uint256 public constant MINT_RATE = 1000; // Tokens per hour
    uint256 private lastMintTime = block.timestamp - 1 hours;
    uint256 public constant MAX_SUPPLY = 1000000000; // Token total suplly

    address public dev; // Deployer

    modifier onlyOwner() {
        require(msg.sender == dev, "Caller is not the owner");
        _;
    }

    constructor(string memory name, string memory symbol) ERC20(name, symbol) { // Set token name && symbol
        dev = msg.sender;
    }

    function mint(address account, uint256 amount) public onlyOwner {
        require(account != address(0), "ERC20: mint to the zero address");
        require(block.timestamp >= lastMintTime + 1 hours, "Minting: Wait for the next minting window");
        require(amount <= MINT_RATE, "Minting: Exceeds the mint rate limit");
        require(totalSupply() + amount <= MAX_SUPPLY, "Minting: Exceeds max supply");

        _mint(account, amount);
        lastMintTime = block.timestamp;
    }
}