// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../lib/forge-std/src/Test.sol";
import "../src/Standards/ERC-721R.sol";

contract SimpleNFTCollectionTest is Test {
    SimpleNFTCollection nft;
    address owner;
    uint256 mintPrice;

    function setUp() public {
        owner = address(this);
        nft = new SimpleNFTCollection("ipfs://BaseURI/");
        mintPrice = nft.mintPrice();
    }

    function testMint() public {
        uint256 mintAmount = 5;
        for (uint256 i = 0; i < mintAmount; i++) {
            vm.startPrank(owner);
            nft.mint{value: mintPrice}();
            vm.stopPrank();
        }

        for (uint i = 0; i < mintAmount; i++) {
            assertEq(nft.ownerOf(i), owner);
        }
    }

    function testFailMintWithoutPayment() public {
        vm.startPrank(owner);
        nft.mint();
        vm.stopPrank();
    }

    function testSetBaseURI() public {
        vm.startPrank(owner);
        nft.mint{value: mintPrice}();
        vm.stopPrank();

        vm.startPrank(owner);
        nft.setBaseURI("ipfs://NewBaseURI/");
        vm.stopPrank();

        assertEq(nft.tokenURI(0), "ipfs://NewBaseURI/0");
    }

    function testFailSetBaseURIByNonOwner() public {
        address nonOwner = address(1);
        vm.startPrank(nonOwner);
        nft.setBaseURI("ipfs://NewBaseURI/");
        vm.stopPrank();
    }

    function testFailWithdrawByNonOwner() public {
        address nonOwner = address(1);

        vm.prank(nonOwner);
        vm.expectRevert("Not the owner");
        nft.withdraw();
    }
}