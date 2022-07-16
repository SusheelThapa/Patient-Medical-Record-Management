# Patient-Record-Management-System

Patient Record Management System based on blockchain technology

## Setting up Project

### Requirement

- `nodejs`

### Installation

#### For Compilation of Solidity Files

- First of all install the node modules along with hardhat

  ```sh
  npm install --save-dev hardhat
  ```

  _You can see that it has created a folder `node_modules`_

- Compile the solidity file

  ```sh
  npx hardhat compile
  ```

  _It will show "Compiled 1 solidity file successfully"_

#### For testing Solidity files

- For testing you need to install some other packages. So go on install it

  ```sh
  npm install --save-dev @nomiclabs/hardhat-ethers ethers @nomiclabs/hardhat-waffle ethereum-waffle chai
  ```

- Run the test script

  ```sh
  npx hardhat test
  ```
