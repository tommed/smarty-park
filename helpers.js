require('dotenv').config();
const { ethers } = require("ethers");
const { getContractAt } = require("@nomiclabs/hardhat-ethers/internal/helpers");

const { PRIVATE_KEY, NETWORK, ALCHEMY_API_KEY } = process.env;

function getProvider() {
  return ethers.getDefaultProvider(NETWORK, {
      alchemy: ALCHEMY_API_KEY,
  });
}

function getAccount() {
  return new ethers.Wallet(PRIVATE_KEY, getProvider());
}

function getContract(contractName, hre, addr) {
  const account = getAccount();
  return getContractAt(hre, contractName, addr, account);
}

module.exports = {
  getAccount,
  getContract,
}