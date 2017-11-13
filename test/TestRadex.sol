pragma solidity ^0.4.2;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Radex.sol";

contract TestRadex {
  function testTokenAddress() {
    Radex rdx = Radex(DeployedAddresses.Radex());
    uint256 feeMultiplier = rdx.feeMultiplier();

    Assert.equal(feeMultiplier, 1000, "Radex charges market takers 0.1% fee and gives it to market makers.");
  }
}
