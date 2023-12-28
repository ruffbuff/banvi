// scripts/deploy.js

const hre = require("hardhat");

async function main() {
  // Получение контрактов, которые вы хотите задеплоить
  const Whale = await hre.ethers.getContractFactory("Whale");

  // Здесь вы можете указать параметры для конструктора контракта
  const baseURI = "ipfs://your_base_uri/";
  const notRevealedURI = "ipfs://your_not_revealed_uri/";

  // Деплой контракта
  const whale = await Whale.deploy(baseURI, notRevealedURI);

  // Ожидание, пока транзакция деплоя будет добыта
  await whale.deployed();

  console.log("Whale deployed to:", whale.address);
}

// Рекомендуемый шаблон для использования async/await в Hardhat
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });