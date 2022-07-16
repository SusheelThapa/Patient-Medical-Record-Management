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

    /*It checks if the msg.sender is patient or not*/
    modifier onlyPatient() {
        require(patients[msg.sender].id > 0, "You aren't patient");
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
    mapping(address => address[]) permissions;

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
    function updatePatientMedicalReport(
        string memory diagnosis,
        string memory medicine,
        address patient_address
    ) public onlyRegisterDoctor {
        // Checking if the Doctor who is updated the patient medical history has permission or not
        bool permission_status;
        for (uint256 i = 0; i < permissions[patient_address].length; i++) {
            if (permissions[patient_address][i] == msg.sender) {
                permission_status = true;
            }
        }
        require(
            permission_status == true,
            "You don't have permission to update this patient medical history"
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
    function givePermission(address doctor_address) public onlyPatient {
        permissions[msg.sender].push(doctor_address);
    }

    // Remove permission for the doctor to update medical history of a particular patient
    function removePermission(address doctor_address) public {
        /*Here the passed argument is redundant*/
        permissions[msg.sender].pop();
    }

    /*Get the doctor detail*/
    function getDoctor(address doctor_address)
        public
        view
        returns (Doctor memory)
    {
        return doctors[doctor_address];
    }

    /*Get the patient detail*/
    function getPatient(address patient_address)
        public
        view
        returns (Patient memory)
    {
        return patients[patient_address];
    }

    /*Check if the doctor has got the permission or not*/
    function checkPermission(address doctor_address, address patient_address)
        public
        view
        returns (bool)
    {
        for (uint256 i = 0; i < permissions[patient_address].length; i++) {
            if (doctor_address == permissions[patient_address][i]) {
                return true;
            }
        }
        return false;
    }
}
