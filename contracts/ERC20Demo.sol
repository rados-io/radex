pragma solidity ^0.4.11;

import "./ERC20.sol";

contract ERC20Demo is StandardToken {
  string public name        = "ERC20Demo";
  string public symbol      = "ERC20Demo";
  uint   public decimals    = 2;
  uint   public totalSupply = 1000000000000000;

  function ERC20Demo(address owner) {
    totalSupply     = totalSupply;
    balances[owner] = totalSupply;
  }
}
