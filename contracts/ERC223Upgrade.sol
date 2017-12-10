pragma solidity ^0.4.11;


import "./SafeMath.sol";
import "./ERC20.sol";
import "./ERC223.sol";


contract ERC223Upgrade {
    using SafeMath for uint256;
    string public name;
    string public symbol;
    ERC20 token;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event ERC223Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);

    // Constructor
    // Call it with the address of the underlying ERC20 token, its name and symbol
    function ERC223Upgrade(address erc20token, string _name, string _symbol) {
      token  = ERC20(erc20token);
      symbol = _symbol;
      name   = _name;
    }

    // simple shims for trivial operations
    function balanceOf(address _owner) public constant returns (uint256) {
      return token.balanceOf(_owner);
    }
    function decimals() constant returns (uint8) {
      return token.decimals();
    }
    function totalSupply() constant returns (uint256) {
      return token.totalSupply();
    }

    // ERC223 compatible transfer
    function transfer(address _to, uint _value, bytes _data) returns (bool success) {
      if (isContract(_to)) {
        return transferToContract(_to, _value, _data);
      } else {
        return transferToAddress(_to, _value, _data);
      }
    }

    function transfer(address _to, uint _value) returns (bool success) {
      // standard function transfer similar to ERC20 transfer with no _data
      // added due to backwards compatibility reasons
      bytes memory empty;
      if (isContract(_to)) {
        return transferToContract(_to, _value, empty);
      } else {
        return transferToAddress(_to, _value, empty);
      }
    }

    // helpers
    // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
    function isContract(address _addr) private returns (bool is_contract) {
      uint256 length;
      assembly {
        // retrieve the size of the code on target address, this needs assembly
        length := extcodesize(_addr)
      }
      return length > 0;
    }

    //function that is called when transaction target is an address
    function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
      success = token.transferFrom(msg.sender, _to, _value);
      if (!success) { revert(); }
      Transfer(msg.sender, _to, _value);
      ERC223Transfer(msg.sender, _to, _value, _data);
    }

    //function that is called when transaction target is a contract
    function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
      success = token.transferFrom(msg.sender, _to, _value);
      if (!success) { revert(); }
      ContractReceiver reciever = ContractReceiver(_to);
      reciever.tokenFallback(msg.sender, _value, _data);
      Transfer(msg.sender, _to, _value);
      ERC223Transfer(msg.sender, _to, _value, _data);
    }
}
