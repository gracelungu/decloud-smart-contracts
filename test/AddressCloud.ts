import { expect } from "chai";
import { Contract } from "ethers";
import { ethers } from "hardhat";

describe.only("Address Cloud", function () {
  let contract: Contract;

  beforeEach(async () => {
    const [signer] = await ethers.getSigners();
    const Cloud = await ethers.getContractFactory("AddressCloud");
    contract = await Cloud.deploy(signer.address);
    await contract.deployed();
  });

  it("Should create a file type", async () => {
    await contract.createFileType("test");
    const fileTypes = await contract.getFileTypes();
    expect(fileTypes).to.contains("test");
  });
});
