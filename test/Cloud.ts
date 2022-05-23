import { expect } from "chai";
import { Contract } from "ethers";
import { ethers } from "hardhat";

describe("Cloud", function () {
  let cloudContract: Contract;

  beforeEach(async () => {
    const Cloud = await ethers.getContractFactory("Cloud");
    cloudContract = await Cloud.deploy();
    await cloudContract.deployed();
  });

  it("Should create an address cloud", async () => {
    await cloudContract.createAddressCloud();
    const address = await cloudContract.getOwnerAddressCloud();
    expect(address).not.to.equal(ethers.constants.AddressZero);
  });

  it("Should transfer the ownership", async () => {
    const [, signer] = await ethers.getSigners();
    await cloudContract.createAddressCloud();
    await cloudContract.transferOwnership(signer.address);
    const address = await cloudContract.getOwnerAddressCloud();
    expect(address).to.equal(ethers.constants.AddressZero);
  });
});
