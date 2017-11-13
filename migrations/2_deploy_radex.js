var Radex = artifacts.require("./Radex.sol");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(Radex);
};
