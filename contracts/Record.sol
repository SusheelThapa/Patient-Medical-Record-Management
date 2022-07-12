//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 <0.9.0;
pragma experimental ABIEncoderV2;

contract Token {
    address owner;
    uint256 public total_doctors = 0;
    uint256 public total_patients = 0;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Only owner can access.");
        _;
    }

    modifier onlyRegisterDoctor() {
        require(doctors[msg.sender].registered, "You are not doctor");
        _;
    }

    struct Doctor {
        string first_name;
        string last_name;
        uint8 age;
        string gender;
        string department;
        bool registered;
    }

    mapping(address => Doctor) public doctors;

    function registerDoctor(address doctor_address) public onlyOwner {
        doctors[doctor_address].registered = true;
    }

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

    mapping(address => Patient) public patients;
    mapping(address => MedicalReport[]) medical_reports;
    mapping(address => bool) patient_medical_report_permisson_to_doctor;

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

    function updatePatient(
        string memory diagnosis,
        string memory medicine,
        address patient_address
    ) public onlyRegisterDoctor {
        require(
            patient_medical_report_permisson_to_doctor[msg.sender] == true,
            "You don't have access to update the medical histoy of this patients"
        );

        patients[patient_address].status = PatientDiagnosisStatus.diagnosed;
        medical_reports[patient_address].push(
            MedicalReport(diagnosis, medicine, patient_address)
        );
        patients[patient_address].total_medical_checkup += 1;
    }

    function getMedicalReports(address patient_address)
        public
        view
        returns (MedicalReport[] memory)
    {
        return medical_reports[patient_address];
    }

    /*These are the function to be executed by Patient only*/
    function givePermission(address doctor_address) public {
        require(patients[msg.sender].id > 0, "You aren't patient");
        patient_medical_report_permisson_to_doctor[doctor_address] = true;
    }

    function removePermission(address doctor_address) public {
        require(patients[msg.sender].id > 0, "You aren't patient");
        patient_medical_report_permisson_to_doctor[doctor_address] = false;
    }
}
