var Saturn = artifacts.require("./Saturn.sol");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(Saturn);
};
