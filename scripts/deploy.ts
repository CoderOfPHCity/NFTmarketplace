import { ethers } from "hardhat";

async function main() {


  const lock = await ethers.deployContract("NFTMarketplace");

  await lock.waitForDeployment();

}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
