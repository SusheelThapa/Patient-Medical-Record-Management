//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 <0.9.0;
pragma experimental ABIEncoderV2;

contract Record {
    /*State variables*/
    address public owner;
    uint256 public total_doctors = 0;
    uint256 public total_patients = 0;

    /*Constructor*/
    constructor() {
        owner = msg.sender;
    }

    /*Modifier*/

    /*It checks if the person who is access this is owner or not*/
    modifier onlyOwner() {
        require(owner == msg.sender, "Only owner can access.");
        _;
    }

    /*It checks if the doctor is registered doctor or not*/
    modifier onlyRegisterDoctor() {
        require(doctors[msg.sender].registered, "You are not doctor");
        _;
    }

    /*Custom made Data types*/
    enum PatientDiagnosisStatus {
        not_diagnose,
        diagnosed,
        diagnosing
    }

    struct MedicalReport {
        string diagnosis;
        string medicine;
        address checked_by_doctor;
    }

    struct Patient {
        uint256 id;
        string first_name;
        string last_name;
        uint8 age;
        string gender;
        uint8 total_medical_checkup;
        PatientDiagnosisStatus status;
    }

    struct Doctor {
        string first_name;
        string last_name;
        uint8 age;
        string gender;
        string department;
        bool registered;
    }

    /*Mapping functions*/
    mapping(address => Doctor) doctors;
    mapping(address => Patient) public patients;
    mapping(address => MedicalReport[]) medical_reports;
    mapping(address => bool) patient_medical_report_permisson_to_doctor;

    /*Functions*/

    // It is used to register the doctor that we have added
    function registerDoctor(address doctor_address) public onlyOwner {
        doctors[doctor_address].registered = true;
    }

    // Adding the doctor
    function addDoctor(
        address doctor_address,
        string memory first_name,
        string memory last_name,
        uint8 age,
        string memory gender,
        string memory department
    ) public onlyOwner {
        doctors[doctor_address] = Doctor(
            first_name,
            last_name,
            age,
            gender,
            department,
            false
        );
        total_doctors += 1;
    }

    function getDoctor(address doctor_address)
        public
        view
        returns (Doctor memory)
    {
        return doctors[doctor_address];
    }

    function getPatient(address patient_address)
        public
        view
        returns (Patient memory)
    {
        return patients[patient_address];
    }

    // Adding the patient
    function addPatient(
        address patient_address,
        string memory first_name,
        string memory last_name,
        uint8 age,
        string memory gender
    ) public onlyOwner {
        total_patients += 1;
        patients[patient_address] = Patient(
            total_patients,
            first_name,
            last_name,
            age,
            gender,
            0,
            PatientDiagnosisStatus.not_diagnose
        );
    }

    // Updating the medical history of the patients
    function updatePatient(
        string memory diagnosis,
        string memory medicine,
        address patient_address
    ) public onlyRegisterDoctor {
        // Checking if the Doctor who is updated the patient medical history has permission or not
        require(
            patient_medical_report_permisson_to_doctor[msg.sender] == true,
            "You don't have access to update the medical histoy of this patients"
        );

        // Updating patients medical history
        patients[patient_address].status = PatientDiagnosisStatus.diagnosed;
        medical_reports[patient_address].push(
            MedicalReport(diagnosis, medicine, patient_address)
        );
        patients[patient_address].total_medical_checkup += 1;
    }

    // Returns all the medical history of the patient
    function getMedicalReports(address patient_address)
        public
        view
        returns (MedicalReport[] memory)
    {
        return medical_reports[patient_address];
    }

    // Give permission to the doctor to update medical history of a particular patients
    function givePermission(address doctor_address) public {
        // Check it the msg.sender is patient or not.
        require(patients[msg.sender].id > 0, "You aren't patient");

        patient_medical_report_permisson_to_doctor[doctor_address] = true;
    }

    // Remove permission for the doctor to update medical history of a particular patient
    function removePermission(address doctor_address) public {
        // Check it the msg.sender is patient or not.
        require(patients[msg.sender].id > 0, "You aren't patient");

        patient_medical_report_permisson_to_doctor[doctor_address] = false;
    }
}
