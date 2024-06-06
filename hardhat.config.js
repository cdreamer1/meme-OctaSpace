/** @type import('hardhat/config').HardhatUserConfig */
require('dotenv').config();
require("@nomicfoundation/hardhat-toolbox");
require("@nomicfoundation/hardhat-chai-matchers");
require("@nomiclabs/hardhat-truffle4");

const { 
  OCTASPACE_API_URL, 
  METAMASK_PRIVATE_KEY,
  ETHEREUM_API_KEY,
} = process.env;

module.exports = {
  solidity: {
    version: "0.8.24",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      },
      viaIR: true,
    }
  },
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      chainId: 1337
    },
    octaspace: {
      url: OCTASPACE_API_URL,
      chainId: 800001,
      accounts: [`0x${METAMASK_PRIVATE_KEY}`]
    },
  },
  sourcify: {
    enabled: false
  },
  etherscan: {
    apiKey: ETHEREUM_API_KEY,
    customChains: [
      {
        network: "Sepolia",
        chainId: 11155111,
        urls: {
          apiURL: "https://sepolia.infura.io/v3/",
          browserURL: 'https://sepolia.etherscan.io'
        }
      }
    ]
  },
};
