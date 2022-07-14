const { expect } = require("chai");
const { upgrades, ethers, run } = require("hardhat");

describe("Election contract", function () {
  let Record;
  let PatientDataBaseCompany;
  let owner;
  let doctor;
  let patient;
  let addrs;

  beforeEach(async function () {
    /*Get the instance of the contracts*/
    Record = await ethers.getContractFactory("Record");

    /*Get all the address of the test account*/
    [owner, doctor, patient, ...addrs] = await ethers.getSigners();

    /*Deploy the contracts*/
    PatientDataBaseCompany = await Record.deploy();
    await PatientDataBaseCompany.deployed();

    /*Add the doctor to the contract*/

    await PatientDataBaseCompany.addDoctor(
      doctor.address,
      "Susheel",
      "Thapa",
      30,
      "Male",
      "Neurology"
    );

    /*Register the doctor*/
    await PatientDataBaseCompany.registerDoctor(doctor.address);
  });

  describe("Deployment", function () {
    it("Should set the right owner", async function () {
      expect(await PatientDataBaseCompany.owner()).to.equal(owner.address);
    });
  });

  describe("Doctors", function () {
    it("Total number of Doctor", async function () {
      expect(await PatientDataBaseCompany.total_doctors()).to.equal(1);
    });

    it("Doctor Detail", async function () {
      let doctor_details = await PatientDataBaseCompany.getDoctor(
        doctor.address
      );

      expect(doctor_details.at(0)).to.equal("Susheel");
      expect(doctor_details.at(1)).to.equal("Thapa");
      expect(doctor_details.at(2)).to.equal(30);
      expect(doctor_details.at(3)).to.equal("Male");
      expect(doctor_details.at(4)).to.equal("Neurology");
      expect(doctor_details.at(5)).to.equal(true);
    });
  });
});
