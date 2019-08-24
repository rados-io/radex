pragma solidity ^0.4.11;

import "./SafeMath.sol";
import "./ERC20.sol";
import "./ERC223.sol";


contract Radex is ContractReceiver {
  using SafeMath for uint256;

  struct Order {
    address owner;
    address sellToken;
    address buyToken;
    uint256 amount;
    uint256 priceMul;
    uint256 priceDiv;
  }

  // fee to be paid towards market makers
  // fee amount = trade amount divided by feeMultiplier
  uint256 public  feeMultiplier;
  address private admin;
  address private etherAddress = 0x0;

  // person => token => balance
  mapping(address => mapping(address => uint256)) public balances;
  mapping(address => mapping(address => uint256)) public commitments;

  mapping(uint256 => Order) orderBook;
  uint256 public latestOrderId = 0;

  event Deposit(address indexed _token, address indexed _owner, uint256 _amount, uint256 _time);
  event Withdrawal(address indexed _token, address indexed _owner, uint256 _amount, uint256 _time);

  event NewOrder(uint256 _id, address indexed _owner, address indexed _sellToken, address indexed _buyToken, uint256 _amount, uint256 _priceMul, uint256 _priceDiv, uint256 _time);
  event OrderCancelled(uint256 indexed _id, uint256 _time);
  event OrderFulfilled(uint256 indexed _id, uint256 _time);

  event MarketMaker(address indexed _owner, address indexed _token, uint256 _amount, uint256 _time);
  event Trade(address indexed _from, address indexed _to, uint256 indexed _orderId, uint256 _soldTokens, uint256 _boughtTokens, uint256 _time);

  function Radex() {
    feeMultiplier = 1000;
    admin = msg.sender;
  }

  function createOrder(address sellToken, address buyToken, uint256 amount, uint256 priceMul, uint256 priceDiv) returns(uint256 orderId) {
    if (amount == 0) { revert(); }
    if (priceMul == 0) { revert(); }
    if (priceDiv == 0) { revert(); }
    if (sellToken == buyToken) { revert(); }
    if (balances[msg.sender][sellToken] < amount) { revert(); }
    if (amount.mul(priceDiv) % priceMul != 0) { revert(); }
    if (amount.mul(priceMul).div(priceDiv) == 0) { revert(); }

    orderId = latestOrderId++;
    orderBook[orderId] = Order(msg.sender, sellToken, buyToken, amount, priceMul, priceDiv);

    balances[msg.sender][sellToken] = balances[msg.sender][sellToken].sub(amount);
    commitments[msg.sender][sellToken] = commitments[msg.sender][sellToken].add(amount);

    NewOrder(orderId, msg.sender, sellToken, buyToken, amount, priceMul, priceDiv, now);
  }

  function cancelOrder(uint256 orderId) {
    Order storage order = orderBook[orderId];
    if (order.amount == 0) { revert(); }
    if (msg.sender != order.owner) { revert(); }

    commitments[msg.sender][order.sellToken] = commitments[msg.sender][order.sellToken].sub(order.amount);
    balances[msg.sender][order.sellToken] = balances[msg.sender][order.sellToken].add(order.amount);

    OrderCancelled(orderId, now);
  }

  function executeOrder(uint256 orderId, uint256 amount) {
    if (orderId > latestOrderId) { revert(); }
    Order storage order    = orderBook[orderId];
    if (amount.mul(order.priceMul) % order.priceDiv != 0) { revert(); }
    uint256 buyTokenAmount = amount.mul(order.priceMul).div(order.priceDiv);
    if (amount == 0) { revert(); }
    if (order.amount < amount) { revert(); }
    if (msg.sender == order.owner) { revert(); }
    if (balances[msg.sender][order.buyToken] < buyTokenAmount) { revert(); }

    uint256 fee = amount.div(feeMultiplier);

    balances[order.owner][order.buyToken]     = balances[order.owner][order.buyToken].add(buyTokenAmount);
    balances[msg.sender][order.buyToken]      = balances[msg.sender][order.buyToken].sub(buyTokenAmount);
    balances[msg.sender][order.sellToken]     = balances[msg.sender][order.sellToken].add(amount).sub(fee);
    balances[order.owner][order.sellToken]    = balances[order.owner][order.sellToken].add(fee);

    commitments[order.owner][order.sellToken] = commitments[order.owner][order.sellToken].sub(amount);
    order.amount = order.amount.sub(amount);
    if (order.amount == 0) { OrderFulfilled(orderId, now); }

    Trade(msg.sender, order.owner, orderId, amount, buyTokenAmount, now);
    MarketMaker(order.owner, order.sellToken, fee, now);
  }


  function redeem(address token, uint256 value) {
    if (value == 0) { revert(); }
    address caller = msg.sender;
    if (value > balances[caller][token]) { revert(); }

    balances[caller][token] = balances[caller][token].sub(value);
    // ETH transfers and token transfers need to be handled differently
    if (token == etherAddress) {
      caller.transfer(value);
    } else {
      ERC223(token).transfer(caller, value);
    }
    Withdrawal(token, msg.sender, value, now);
  }

  function balanceOf(address token, address user) constant returns (uint256) {
    return balances[user][token];
  }

  function commitmentsOf(address token, address user) constant returns (uint256) {
    return commitments[user][token];
  }

  // deposits
  // we're not using the third argument so we comment it out
  // to silence solidity linter warnings
  function tokenFallback(address _from, uint _value, bytes /* _data */) {
    // ERC223 token deposit handler
    balances[_from][msg.sender] = balances[_from][msg.sender].add(_value);
    Deposit(msg.sender, _from, _value, now);
  }

  function fund() payable {
    // ETH deposit handler
    balances[msg.sender][etherAddress] = balances[msg.sender][etherAddress].add(msg.value);
    Deposit(etherAddress, msg.sender, msg.value, now);
  }

  // register the ERC20<>ERC223 pair with the smart contract
  function register(address erc20token, address erc223token) {
    if (msg.sender != admin) { revert(); } // only owner
    ERC20 erc20 = ERC20(erc20token);
    uint256 supply = erc20.totalSupply();
    erc20.approve(erc223token, supply);
  }
}
