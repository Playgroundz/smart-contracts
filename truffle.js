var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "dust mountain work view talent farm reduce ketchup only fringe bullet bright";

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
networks: {
  ropsten: {
    provider: function() { 
     return new HDWalletProvider(mnemonic, "https://ropsten.infura.io/v3/1b5251d8c8114f0ca0e3187e53db027b") 
    },
    network_id: 3,
    gas: 670000,
   }
   }
};
