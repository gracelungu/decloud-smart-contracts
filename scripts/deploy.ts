import { ethers } from "hardhat";

async function main() {
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const Cloud = await ethers.getContractFactory("Cloud");
  const cloud = await Cloud.deploy();

  await cloud.deployed();

  console.log("Cloud contract deployed to:", cloud.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
