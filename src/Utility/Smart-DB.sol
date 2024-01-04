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
/**
 * @title SmartDB
 * @dev A smart contract for a database of user profiles.
 */
contract SmartDB {                  // SmartDB == Smart contract Data-Base
    struct UserProfile {
        address walletAddress;      // Profile address
        uint256 id;                 // Profile ID
        string avatarPic;           // Profile picture
        string bannerPic;           // Profile banner
        string bioData;             // Short bio
        string[] links;             // Media links: Twitter, Telegram, Discord etc (Optional)
        bool isVerified;            // Is user verified
    }

    uint256 private userIdCounter = 0;
    mapping(uint256 => UserProfile) private userProfiles;
    mapping(address => uint256) private walletToUserId;

    address public owner;
    address public botOperator;

    event UserProfileUpdated(uint256 userId);
    event UserVerified(address walletAddress, uint256 userId);

    /**
     * @dev Modifier that restricts access to only the contract owner or the bot operator
     */
    modifier onlyTeam() {
        require(msg.sender == owner || msg.sender == botOperator, "Unauthorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev Allows the contract owner to set the bot operator address
     * @param _botOperator The address of the bot operator
     */
    function setBotOperator(address _botOperator) external onlyTeam {
        botOperator = _botOperator;
    }

    function verifyUser(address walletAddress) external returns (uint256) {
        require(walletToUserId[walletAddress] == 0, "User already verified");

        uint256 newUserId = ++userIdCounter;
        walletToUserId[walletAddress] = newUserId;
        userProfiles[newUserId] = UserProfile({
            walletAddress: walletAddress,
            id: newUserId,
            avatarPic: "",
            bannerPic: "",
            bioData: "",
            links: new string[](0),
            isVerified: true
        });

        emit UserVerified(walletAddress, newUserId);
        return newUserId;
    }

    /**
     * @dev Updates the profile information of a user
     * @param userId The ID of the user profile to be updated
     * @param avatarPic The new avatar picture
     * @param bannerPic The new profile banner
     * @param bioData The new short bio
     * @param links The new media links
     */
    function updateProfile(uint256 userId, string calldata avatarPic, string calldata bannerPic, string calldata bioData, string[] memory links) external {
        require(userId > 0 && userId <= userIdCounter, "Invalid user ID");
        require(userProfiles[userId].walletAddress == msg.sender, "Unauthorized");

        if (bytes(avatarPic).length > 0 && keccak256(bytes(avatarPic)) != keccak256(bytes("0"))) {
            userProfiles[userId].avatarPic = avatarPic;
        }
        if (bytes(bannerPic).length > 0 && keccak256(bytes(bannerPic)) != keccak256(bytes("0"))) {
            userProfiles[userId].bannerPic = bannerPic;
        }
        if (bytes(bioData).length > 0 && keccak256(bytes(bioData)) != keccak256(bytes("0"))) {
            userProfiles[userId].bioData = bioData;
        }
        if (links.length > 0 && !(links.length == 1 && keccak256(bytes(links[0])) == keccak256(bytes("0")))) {
            userProfiles[userId].links = links;
        }

        emit UserProfileUpdated(userId);
    }

    function updateAvatarPic(uint256 userId, string calldata avatarPic) external onlyTeam {
        userProfiles[userId].avatarPic = avatarPic;
        emit UserProfileUpdated(userId);
    }

    function updateBannerPic(uint256 userId, string calldata bannerPic) external onlyTeam {
        userProfiles[userId].bannerPic = bannerPic;
        emit UserProfileUpdated(userId);
    }

    function updateBioData(uint256 userId, string calldata bioData) external onlyTeam {
        userProfiles[userId].bioData = bioData;
        emit UserProfileUpdated(userId);
    }

    function updateLinks(uint256 userId, string[] memory links) external onlyTeam {
        userProfiles[userId].links = links;
        emit UserProfileUpdated(userId);
    }

    function getProfile(uint256 userId) external view returns (UserProfile memory) {
        return userProfiles[userId];
    }

    function getUserIdByWallet(address walletAddress) external view returns (uint256) {
        uint256 userId = walletToUserId[walletAddress];
        require(userId != 0, "Wallet address is not verified");
        return userId;
    }
}