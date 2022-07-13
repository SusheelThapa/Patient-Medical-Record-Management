const { expect } = require("chai");
const { upgrades, ethers, run } = require("hardhat");

describe("Election contract", function () {
  let Record;
  let PatientDataBaseCompany;
  let owner;
  let addr1;
  let addr2;
  let addrs;

  beforeEach(async function () {
    Record = await ethers.getContractFactory("Record");
    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
    PatientDataBaseCompany = await Record.deploy();

    await PatientDataBaseCompany.deployed();
  });

  describe("Deployment", function () {
    it("Should set the right owner", async function () {
      expect(await PatientDataBaseCompany.owner()).to.equal(owner.address);
    });
  });
});
