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

  it("Should create delete a file type", async () => {
    await contract.createFileType("test");
    const fileTypes = await contract.getFileTypes();
    expect(fileTypes).to.contains("test");

    await contract.deleteType("test");
    const deleteType = await contract.getFileTypes();
    expect(deleteType).not.to.contains("test");
  });

  it("Should create files", async () => {
    const fileType = "testType";
    const file: (string | string | string | number)[] = [
      "test",
      "testUri",
      fileType,
      Date.now(),
    ];

    await contract.createFileType(fileType);

    await contract.createFiles(fileType, [file]);
    const files = await contract.getFiles(fileType);
    const [name, uri, type, timestamp] = files.toString().split(",");

    expect(name).to.be.eq(file[0]);
    expect(uri).to.be.eq(file[1]);
    expect(type).to.be.eq(file[2]);
    expect(timestamp.length).to.be.greaterThan(6);
  });

  it("Should create type and files", async () => {
    const fileType = "testType";
    const file: (string | string | string | number)[] = [
      "test",
      "testUri",
      fileType,
      Date.now(),
    ];

    await contract.createTypeAndFiles(fileType, [file]);
    const files = await contract.getFiles(fileType);
    const [name, uri, type, timestamp] = files.toString().split(",");

    expect(name).to.be.eq(file[0]);
    expect(uri).to.be.eq(file[1]);
    expect(type).to.be.eq(file[2]);
    expect(timestamp.length).to.be.greaterThan(6);
  });

  it("Should delete files", async () => {
    const fileType = "testType";
    const file: (string | string | string | number)[] = [
      "test",
      "testUri",
      fileType,
      Date.now(),
    ];

    await contract.createTypeAndFiles(fileType, [file]);
    const files = await contract.getFiles(fileType);
    const [name] = files.toString().split(",");

    expect(name).to.be.eq(file[0]);

    await contract.deleteFiles(fileType, [file]);

    const deletedFiles = await contract.getFiles(fileType);
    const [deletedFileName] = deletedFiles.toString().split(",");

    expect(deletedFileName).to.be.eq("");
  });
});
