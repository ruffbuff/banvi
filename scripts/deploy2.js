const hre = require("hardhat");

async function main() {
    const baseURI = "ipfs://YourBaseURI/";
    const revealedBaseURI = "ipfs://YourRevealedBaseURI/";

    const Potion = await hre.ethers.getContractFactory("Potion");
    const potion = await Potion.deploy(baseURI, revealedBaseURI);

    await potion.deployed();

    console.log("Potion deployed to:", potion.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});