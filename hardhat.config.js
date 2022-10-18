require('dotenv').config();
require('@nomiclabs/hardhat-ethers');
require('@nomiclabs/hardhat-etherscan');
const { task } = require("hardhat/config");
const { getContract } = require('./helpers.js');

const { PRIVATE_KEY, NETWORK, RPC_URL, SCAN_API_KEY, CARS_CONTRACT_ADDR } = process.env;

// task::disable-car
task("enable-car", "Disable someone's car")
  .addParam("reg", "Car's registration number")
  .addFlag("disable")
  .setAction(async (args, hre) => {
    const contract = await getContract("Cars", hre, CARS_CONTRACT_ADDR);
    const resp = await contract.setCarDisabled(args.reg, args.disable, {
      gasLimit: 500_000,
    });
    console.log(`Transaction Hash: ${resp.hash}`);
  });

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  defaultNetwork: NETWORK,
  networks: {
    goerli: {
      url: RPC_URL,
      accounts: [PRIVATE_KEY],
    }
    // mumbai: {
    //   url: MUMBAI_RPC_URL,
    //   accounts: [PRIVATE_KEY],
    // }
  },
  etherscan: {
    apiKey: SCAN_API_KEY
  }
};
