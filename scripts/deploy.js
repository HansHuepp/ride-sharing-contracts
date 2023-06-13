const hre = require("hardhat");

async function main() {
  const ContractFactory = await hre.ethers.getContractFactory("ContractFactory");
  const contract = await ContractFactory.deploy();

  console.log("Contract deployed to:", contract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
