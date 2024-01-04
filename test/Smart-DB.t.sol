// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../lib/forge-std/src/Test.sol";
import "../src/Utility/Smart-DB.sol";

contract SmartDBTest is Test {
    SmartDB private smartDB;
    address private owner;
    address private user1;
    address private user2;

    function setUp() public {
        owner = address(this);
        user1 = address(0x1);
        user2 = address(0x2);

        smartDB = new SmartDB();

        vm.prank(owner);
        smartDB.setBotOperator(owner);
    }

    function testVerifyUser() public {
        vm.expectRevert("Wallet address is not verified");
        smartDB.getUserIdByWallet(user1);

        vm.prank(owner);
        uint256 userId = smartDB.verifyUser(user1);

        assertEq(smartDB.getUserIdByWallet(user1), userId);
    }

    function testUpdateProfile() public {
        vm.prank(owner);
        uint256 userId = smartDB.verifyUser(user1);

        vm.prank(user1);
        smartDB.updateProfile(userId, "avatar.jpg", "banner.jpg", "Bio", new string[](0));

        SmartDB.UserProfile memory profile = smartDB.getProfile(userId);
        assertEq(profile.avatarPic, "avatar.jpg");
        assertEq(profile.bannerPic, "banner.jpg");
        assertEq(profile.bioData, "Bio");
    }

    function testUnauthorizedAccess() public {
        vm.expectRevert("Invalid user ID");
        smartDB.updateProfile(1, "avatar.jpg", "banner.jpg", "Bio", new string[](0));
    }
}