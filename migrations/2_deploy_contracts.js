var token = artifacts.require("./IOGToken.sol");

module.exports = function(deployer) {
  deployer.deploy(token);
};
