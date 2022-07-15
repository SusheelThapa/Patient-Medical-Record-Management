const { expect } = require("chai");
const { upgrades, ethers, run } = require("hardhat");

describe("Record", function () {
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

    /*Add Patient to the contract*/
    await PatientDataBaseCompany.addPatient(
      patient.address,
      "Samir",
      "Thapa",
      10,
      "Male"
    );
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

  describe("Patient Details", function () {
    it("Total Number of Patient", async function () {
      expect(await PatientDataBaseCompany.total_patients()).to.equal(1);
    });

    it("Patient Detail", async function () {
      let patient_detail = await PatientDataBaseCompany.getPatient(
        patient.address
      );

      expect(await patient_detail.at(1)).to.equal("Samir");
      expect(await patient_detail.at(2)).to.equal("Thapa");
      expect(await patient_detail.at(3)).to.equal(10);
      expect(await patient_detail.at(4)).to.equal("Male");
    });
  });

  describe("Permission and Update medical History of Patient", function () {
    beforeEach(async function () {
      /*Give permission for the doctor to update the medical history of the Patient*/
      await PatientDataBaseCompany.connect(patient).givePermission(
        doctor.address
      );

      /*Updating the medical history of the patient*/
      await PatientDataBaseCompany.connect(doctor).updatePatientMedicalReport(
        "Fever",
        "Paracetamol",
        patient.address
      );
      await PatientDataBaseCompany.connect(doctor).updatePatientMedicalReport(
        "Headache",
        "NIMS",
        patient.address
      );
    });

    it("Had doctor got permission to edit medical report of patients?", async function () {
      expect(
        await PatientDataBaseCompany.checkPermission(
          doctor.address,
          patient.address
        )
      ).to.equal(true);
    });

    it("Checking updated medical history of user", async function () {
      let patient_medical_report = await PatientDataBaseCompany.connect(
        doctor
      ).getMedicalReports(patient.address);

      expect(await patient_medical_report.at(0).at(0)).to.equal("Fever");
      expect(await patient_medical_report.at(0).at(1)).to.equal("Paracetamol");
      expect(await patient_medical_report.at(0).at(2)).to.equal(
        patient.address
      );

      expect(await patient_medical_report.at(1).at(0)).to.equal("Headache");
      expect(await patient_medical_report.at(1).at(1)).to.equal("NIMS");
      expect(await patient_medical_report.at(1).at(2)).to.equal(
        patient.address
      );
    });

    it("Removing Permission", async function () {
      await PatientDataBaseCompany.connect(patient).removePermission(
        doctor.address
      );

      expect(
        await PatientDataBaseCompany.connect(patient).checkPermission(
          doctor.address,
          patient.address
        )
      ).to.equal(false);
    });
  });
});
