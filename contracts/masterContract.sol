// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 < 0.9.0;

contract Custom_Send {
    function customSend(uint256 value, address receiver) public returns (bool) {}
}

contract Vachiralong_Coin {
  uint256 public tokenPrice;
  event Purchase(address buyer, uint256 amount);
  event Transfer(address sender, address receiver, uint256 amount);
  event Sell(address seller, uint256 amount);
  event Price(uint256 price);
  mapping(address => uint256) balances;

  address public owner;

  Custom_Send _customSend;

  modifier isOwner() {
    require(msg.sender == owner, "Unauthorised");
    _;
  }

  constructor(uint256 initPrice, address customAddr) {
      owner = msg.sender;
      balances[msg.sender] = initPrice * 10 ether;
      tokenPrice = initPrice;
      _customSend = Custom_Send(customAddr);
  }

  function buyToken(uint256 amount) public payable returns (bool) {
    require(msg.value == amount * tokenPrice && amount > 0);
    balances[msg.sender] += amount;
    tokenPrice *= 2;
    emit Price(tokenPrice);
    emit Purchase(msg.sender, amount);
    return true;
  }
  
  function transfer(address recipient, uint256 amount) public returns (bool) {
    require(balances[msg.sender] >= amount && amount > 0);
    balances[msg.sender] -= amount;
    balances[recipient] += amount;
    emit Transfer(msg.sender, recipient, amount);
    return true;
  }

  function sellToken(uint256 amount) public returns (bool) {
    require(balances[msg.sender] >= amount && amount > 0);
    balances[msg.sender] -= amount;
    _customSend.customSend(amount * tokenPrice, msg.sender);
    emit Sell(msg.sender, amount);
    return true;
  }

  function changePrice(uint256 price) public isOwner returns (bool) {
    tokenPrice = price;
    emit Price(tokenPrice);
    return true;
  }

  function getBalance() public view returns (uint256) {
    return balances[msg.sender];
  }

  function setCustomLib(address addr) public isOwner {
    _customSend = Custom_Send(addr);
  }
}
