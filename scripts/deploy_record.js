async function main() {
  const [deployer] = await ethers.getSigners();

  console.log(
    "Deploying the contract Record with the account: ",
    await deployer.getAddress()
  );

  console.log("Account Balance: ", (await deployer.getBalance()).toString());

  /*Deploying the contracts*/
  const Record = await ethers.getContractFactory("Record");
  const PatientDataBaseCompany = await Record.deploy();
  await PatientDataBaseCompany.deployed();

  console.log("Election contract address:", PatientDataBaseCompany.address);

  saveFrontendFiles(PatientDataBaseCompany);

  function saveFrontendFiles(PatientDataBaseCompany) {
    const file_system = require("fs");

    const contracts_directory = __dirname + "/../Data";

    if (!file_system.existsSync(contracts_directory)) {
      file_system.mkdirSync(contracts_directory);
    }

    file_system.writeFileSync(
      contracts_directory + "/contract-address.json",
      JSON.stringify({ Record: PatientDataBaseCompany.address }, undefined, 2)
    );

    const RecordArtifact = artifacts.readArtifactSync("Record");

    file_system.writeFileSync(
      contracts_directory + "/Record.json",
      JSON.stringify(RecordArtifact, null, 2)
    );
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
