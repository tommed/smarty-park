require('dotenv').config();
require('@nomiclabs/hardhat-ethers');
require('@nomiclabs/hardhat-etherscan');

const { PRIVATE_KEY, NETWORK, RPC_URL, SCAN_API_KEY } = process.env;

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
