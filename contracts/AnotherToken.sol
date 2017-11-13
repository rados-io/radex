pragma solidity ^0.4.11;

import "./ERC223.sol";

contract AnotherToken is ERC223Token {
  string public name = "AnotherToken";
  string public symbol = "ANT";
  uint public decimals = 6;
  uint public INITIAL_SUPPLY = 10000000000;

  function AnotherToken() {
    totalSupply = INITIAL_SUPPLY;
    balances[msg.sender] = INITIAL_SUPPLY;
  }
}
