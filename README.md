# Radex - decentralized exchange for Ethereum ERC223 tokens
[![Build Status](https://travis-ci.org/rados-io/radex.svg?branch=master)](https://travis-ci.org/rados-io/radex)[![Coverage Status](https://coveralls.io/repos/github/rados-io/radex/badge.svg?branch=master)](https://coveralls.io/github/rados-io/radex?branch=master)

The smart contract backend for [Radex](https://saturn.network).

Big thanks to [Ethereum](http://ethereum.org), [Truffle](http://truffleframework.com), [OpenZeppelin](http://openzeppelin.org) and [Colony](https://github.com/sc-forks/solidity-coverage) for the open source tools and learning materials.

You can view the smart contract on [EtherScan here](https://rinkeby.etherscan.io/address/0x93b4f259303beb1508428afc0f8666d9d8dba437).

## Ethereum transaction fee structure

Even though we, the creators of Radex, do not take any fees for using the exchange, due to the decentralized nature of the exchange you will still have to pay ethereum transaction fees. So how much will it cost?

According to [EthGasStation](https://ethgasstation.info/index.php) the recommended Ethereum gas price is 1 Gwei. Using this number we can calculate how much money each action on Radex will cost you in practice. I'll link to actual Ethereum transactions so you can confirm these numbers for yourself.

Note that these numbers are fixed and identical for everybody, they do not change depending on transaction amount. If you plan to trade large volumes you might not even notice these transaction fees.

Action  | Gas used  |  USD fee (approx.)
--|---|--
[Deposit ETH](https://rinkeby.etherscan.io/tx/0x3f05b6252589c3c6ee437f38abc0d0e427cc7aa5eb44587b0a49d719322ac343)  | 29948 gas  |  $0.014
[Deposit STN](https://rinkeby.etherscan.io/tx/0xe24e41a2fa985bc16a7fe3f8bbaf6b587ef7d7546a5b0b6472b85db360539498)  | 50930 gas | $0.024
[Create Order](https://rinkeby.etherscan.io/tx/0xf589edbbbe9f8208d61ba99ec2f43dd28973a288d7d919afbf886027a9518933)  | 151560 gas |  $0.071
[Trade](https://rinkeby.etherscan.io/tx/0x0f44bb9ad8dc299abd002b3ae3bdc8ee231d459bb7d386b41eda8d787e679c5a)  | 53626 gas  |  $0.025
[Withdraw ETH](https://rinkeby.etherscan.io/tx/0x4f0f4f6e023f50ac2da654c609632773f0a63640a1ad8ec135b5b2899a833201)  | 38386 gas  | $0.018
[Withdraw STN](https://rinkeby.etherscan.io/tx/0xbb2bff12f72e2e232bfffa1e1e24cc964acea043e5fb36abaf9d5c51f34c532f)  | 51070 gas | $0.024

These are **the lowest fees of any cryptocurrency exchange** that currently exists.

Happy trading!
