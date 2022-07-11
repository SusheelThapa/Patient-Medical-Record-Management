//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 <0.9.0;

contract Token {
    address public owner;
    uint256 public total_doctor = 0;

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

    function addDoctor(
        string memory first_name,
        string memory last_name,
        uint8 age,
        string memory gender,
        string memory department
    ) external {
        doctors[msg.sender] = Doctor(
            first_name,
            last_name,
            age,
            gender,
            department,
            false
        );
        total_doctor += 1;
    }
}
