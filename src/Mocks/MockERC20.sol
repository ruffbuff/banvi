// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20 {
    uint256 public constant MINT_RATE = 1000;
    uint256 private lastMintTime;
    uint256 public constant MAX_SUPPLY = 1000000000;

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        lastMintTime = 0;
    }

    function mint(address account, uint256 amount) public {
        require(block.timestamp >= lastMintTime + 1 hours, "Minting: Wait for the next minting window");
        require(amount <= MINT_RATE, "Minting: Exceeds the mint rate limit");
        require(totalSupply() + amount <= MAX_SUPPLY, "Minting: Exceeds max supply");
        _mint(account, amount);
        lastMintTime = block.timestamp;
    }

    function burn(address account, uint256 amount) public {
        _burn(account, amount);
    }
}