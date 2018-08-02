var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "siren mystery tortoise oil front leg mistake artwork reform sunny lazy put";

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
networks: {
  development: {
    host: "localhost",
    port: 8545,
    network_id: "*", // Match any network id,
    gas: 2990000
  },
  ropsten: {
    provider: function() { 
     return new HDWalletProvider(mnemonic, "https://ropsten.infura.io/v3/1b5251d8c8114f0ca0e3187e53db027b") 
    },
    network_id: 3,
    gas: 2990000,
   }
   }
};
