pragma solidity >=0.7.0 <0.9.0;

contract Vachiralong_Coin {
  uint256 public tokenPrice;
  event Purchase(address buyer, uint256 amount);
  event Transfer(address sender, address receiver, uint256 amount);
  event Sell(address seller, uint256 amount);
  event Price(uint256 price);
  mapping(address => uint256) balances;

  address public owner;

  constructor() {
      owner = msg.sender;
  }

  function buyToken(uint256 amount) public {
    emit Purchase(msg.sender, amount);
  }
  
  function transfer(address recipient, uint256 amount) public {
    emit Transfer(msg.sender, recipient, amount);
  }

  function sellToken(uint256 amount) public {
    emit Sell(msg.sender, amount);
  }

  function changePrice(uint256 price) public {
    require(msg.sender == owner);
    tokenPrice = price;
    emit Price(tokenPrice);
  }

  function getBalance() public view returns (uint256) {
    return balances[msg.sender];
  }
}
