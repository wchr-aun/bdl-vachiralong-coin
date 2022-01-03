// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 < 0.9.0;

import { customLib } from "./customLibrary.sol";

contract Vachiralong_Coin {
  uint256 public tokenPrice;
  address owner;
  uint256 supplies;
  mapping(address => uint256) balances;

  event Purchase(address buyer, uint256 amount);
  event Transfer(address sender, address receiver, uint256 amount);
  event Sell(address seller, uint256 amount);
  event Price(uint256 price);

  constructor(uint256 initPrice) {
      owner = msg.sender;
      tokenPrice = initPrice;
  }

  function buyToken(uint256 amount) public payable returns (bool) {
    require(amount > 0 && msg.value / amount == tokenPrice, "The amount is less than or equal to 0 or the entered ethers are not sufficient");
    balances[msg.sender] += amount;
    supplies += amount;
    emit Purchase(msg.sender, amount);
    return true;
  }

  function sellToken(uint256 amount) public returns (bool) {
    require(amount > 0 && balances[msg.sender] >= amount && amount * tokenPrice > 1, "The token amount is not sufficient");
    balances[msg.sender] -= amount;
    supplies -= amount;
    bool success = customLib.customSend(amount * tokenPrice, msg.sender);
    require(success, "Transaction failed");
    emit Sell(msg.sender, amount);
    return success;
  }
  
  function transfer(address recipient, uint256 amount) public returns (bool) {
    require(amount > 0 && balances[msg.sender] >= amount, "The token amount is not sufficient");
    balances[msg.sender] -= amount;

    balances[recipient] += amount;

    emit Transfer(msg.sender, recipient, amount);
    return true;
  }

  function changePrice(uint256 price) public payable returns (bool) {
    require(msg.sender == owner, "Unauthorised");
    require(address(this).balance + msg.value >= supplies * price, "The entered ethers are not sufficient");
    tokenPrice = price;
    emit Price(tokenPrice);
    return true;
  }

  function getBalance() public view returns (uint256) {
    return balances[msg.sender];
  }
}
