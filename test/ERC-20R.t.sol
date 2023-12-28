// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../lib/forge-std/src/Test.sol";
import "../src/Mocks/MockERC20.sol";

contract SimpleTokenTest is Test {
    MockERC20 token;
    address dev;

    function setUp() public {
        dev = address(this);
        token = new MockERC20("SimpleToken", "STK");
    }

    function testMint() public {
        assertEq(token.totalSupply(), 0);

        uint256 amount = 100;
        vm.warp(block.timestamp + 1 hours);
        token.mint(dev, amount);

        assertEq(token.totalSupply(), amount);
        assertEq(token.balanceOf(dev), amount);
    }

    function testFailMintTooMuch() public {
        uint256 amount = 2000;
        vm.warp(block.timestamp + 1 hours);
        token.mint(dev, amount);
    }

    function testFailMintTooSoon() public {
        uint256 amount = 100;
        token.mint(dev, amount);
    }

    function testFailMintAfterMaxSupply() public {
        uint256 maxSupply = 1000000000;
        uint256 amount = maxSupply + 1;
        vm.warp(block.timestamp + 1 hours);
        token.mint(dev, amount);
    }
}
