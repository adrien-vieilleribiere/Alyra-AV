require("@nomicfoundation/hardhat-toolbox");
const HDWalletProvider = require('@truffle/hdwallet-provider');
require('dotenv').config();

const INfURA_url = 'https://goerli.infura.io/v3/' + `${process.env.INFURA_ID}`;
const privatekey = `${process.env.PRIVATE_KEY_ALYRA_AV}`;
/**
* @type import('hardhat/config').HardhatUserConfig
*/

module.exports = {

  solidity: "0.8.17",

  networks: {

    goerli: {

      url: INfURA_url,

      accounts: [privatekey],

    }
  }
};