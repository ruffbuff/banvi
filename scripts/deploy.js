const hre = require("hardhat");

async function main() {
  const Whale = await hre.ethers.getContractFactory("Whale");

  const baseURI = "https://bafybeidlrfd4yh22ma3gqyogjltuqnzuh4fnyutu63iqn4xpaj3fyze344.ipfs.nftstorage.link/";
  const notRevealedURI = "https://bafybeigtjntmdt2yd5oetnvjstkj3qqiqy2fncsdeaebpwv2uaw27ttfyu.ipfs.nftstorage.link/";

  const gasPrice = hre.ethers.utils.parseUnits("300", "gwei");

  const whale = await Whale.deploy(baseURI, notRevealedURI, {
    gasPrice: gasPrice
  });

  await whale.deployed();

  console.log("Whale deployed to:", whale.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });