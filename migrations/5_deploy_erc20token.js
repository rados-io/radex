var ERC20Demo      = artifacts.require("./ERC20Demo.sol");
var ERC223Upgrade  = artifacts.require("./ERC223Upgrade.sol");

module.exports = (deployer, network, accounts) => {
  deployer.deploy(ERC20Demo, accounts[0]).then(() => {
    return deployer.deploy(ERC223Upgrade, ERC20Demo.address, "Demo223", "D223");
  });
};
