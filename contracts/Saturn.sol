pragma solidity ^0.4.11;

import "./ERC223.sol";

contract Saturn is ERC223Token {
  string public name = "Saturn";
  string public symbol = "STN";
  uint public decimals = 4;
  uint public INITIAL_SUPPLY = 2000000000;

  function Saturn() {
    totalSupply = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
  }
}
