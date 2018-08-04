var HDWalletProvider = require("truffle-hdwallet-provider");

require('dotenv').config();

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*", // Match any network id,
      gas: 5590000,
      gasPrice: 29000000000
    },

    ropsten: {
      provider: function() { 
        return new HDWalletProvider(process.env.MNEMONIC, "https://ropsten.infura.io/v3/" + process.env.INFURA_KEY) 
      },
      network_id: 3,
      gas: 5590000,
      gasPrice: 39000000000
    },

    mainnet: {
      provider: function() { 
        return new HDWalletProvider(process.env.MNEMONIC, "https://mainnet.infura.io/v3/" + process.env.INFURA_KEY) 
      },
      network_id: 1,
      gas: 990000,
      gasPrice: 19000000000
    }
   }
};
