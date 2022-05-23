import { expect } from "chai";
import { Contract } from "ethers";
import { ethers } from "hardhat";

describe("Greeter", function () {
  let cloudContract: Contract;

  beforeEach(async () => {
    const Cloud = await ethers.getContractFactory("Cloud");
    cloudContract = await Cloud.deploy();
    await cloudContract.deployed();
  });

  it("Should create an address cloud", async function () {
    const address = await cloudContract.createAddressCloud();
    console.log(address);
  });
});
