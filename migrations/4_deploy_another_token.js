var AnotherToken = artifacts.require("./AnotherToken.sol");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(AnotherToken);
};
