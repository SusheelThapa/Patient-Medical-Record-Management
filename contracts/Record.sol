//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 <0.9.0;

contract Token {
    address public owner;
    uint256 public total_doctors = 0;
    uint256 public total_patients = 0;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Only owner can access.");
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

    function isDoctorRegister(address doctor_address)
        public
        view
        returns (bool)
    {
        return doctors[doctor_address].registered;
    }

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
    ) external onlyOwner {
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

    struct Patient {
        string first_name;
        string last_name;
        uint8 age;
        string gender;
        uint8 total_medical_checkup;
        PatientDiagnosisStatus status;
    }

    mapping(address => Patient) public patients;

    function addPatient(
        address patient_address,
        string memory first_name,
        string memory last_name,
        uint8 age,
        string memory gender
    ) external onlyOwner {
        patients[patient_address] = Patient(
            first_name,
            last_name,
            age,
            gender,
            0,
            PatientDiagnosisStatus.not_diagnose
        );

        total_patients += 1;
    }
}
