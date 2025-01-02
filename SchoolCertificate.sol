// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SchoolCertificate {
    // Structure to store certificate details
    struct Certificate {
        string studentName;
        string courseName;
        string grade;
        uint256 dateOfIssuance;
        bool exists; // To verify existence
    }

    // Mapping to store certificates by student ID
    mapping(string => Certificate) private certificates;

    // Address of the administrator
    address public admin;

    // Events
    event CertificateIssued(
        string indexed studentId,
        string studentName,
        string courseName,
        string grade,
        uint256 dateOfIssuance
    );

    event AdminChanged(address indexed oldAdmin, address indexed newAdmin);

    // Modifier to restrict access to the admin
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only the administrator can perform this action.");
        _;
    }

    // Constructor to set the initial admin
    constructor() {
        admin = msg.sender;
    }

    // Function to change the admin
    function changeAdmin(address newAdmin) external onlyAdmin {
        require(newAdmin != address(0), "Invalid admin address.");
        address oldAdmin = admin;
        admin = newAdmin;
        emit AdminChanged(oldAdmin, newAdmin);
    }

    // Function to issue a certificate
    function issueCertificate(
        string memory studentId,
        string memory studentName,
        string memory courseName,
        string memory grade,
        uint256 dateOfIssuance
    ) public onlyAdmin {
        require(!certificates[studentId].exists, "Certificate already exists for this student ID.");
        certificates[studentId] = Certificate(studentName, courseName, grade, dateOfIssuance, true);
        emit CertificateIssued(studentId, studentName, courseName, grade, dateOfIssuance);
    }

    // Function to retrieve a certificate by student ID
    function getCertificate(string memory studentId)
        public
        view
        returns (
            string memory studentName,
            string memory courseName,
            string memory grade,
            uint256 dateOfIssuance
        )
    {
        require(certificates[studentId].exists, "Certificate does not exist for this student ID.");
        Certificate memory cert = certificates[studentId];
        return (cert.studentName, cert.courseName, cert.grade, cert.dateOfIssuance);
    }

    // Function to verify the authenticity of a certificate
    function verifyCertificate(string memory studentId) public view returns (bool) {
        return certificates[studentId].exists;
    }
}
