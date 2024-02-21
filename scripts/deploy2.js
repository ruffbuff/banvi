const hre = require("hardhat");

async function main() {
    const baseURI = "https://bafybeihc64srb3je7y6rougybmkc2uqumc4qmux5b5hfjceex4whgtqrsy.ipfs.nftstorage.link/";

    const Potion = await hre.ethers.getContractFactory("Potion");
    const potion = await Potion.deploy(baseURI);

    await potion.deployed();

    console.log("Potion deployed to:", potion.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});