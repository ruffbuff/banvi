const hre = require("hardhat");

async function main() {
    const Merge = await hre.ethers.getContractFactory("Merge");

    const [deployer] = await ethers.getSigners();

    const balance = await deployer.getBalance();
    console.log("Account balance:", balance.toString());
    const gasPrice = hre.ethers.utils.parseUnits("300", "gwei");

    const merge = await Merge.deploy({
        gasPrice: gasPrice
      });
    
      await merge.deployed();

    console.log("Merge contract deployed to:", merge.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });