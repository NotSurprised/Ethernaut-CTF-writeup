# Gatekeeper Two

This gatekeeper introduces a few new challenges. Register as an entrant to pass this level.
Things that might help:
* Remember what you've learned from getting past the first gatekeeper - the first gate is the same.
* The `assembly` keyword in the second gate allows a contract to access functionality that is not native to vanilla Solidity. See [here](https://solidity.readthedocs.io/en/v0.4.23/assembly.html) for more information. The `extcodesize` call in this gate will get the size of a contract's code at a given address - you can learn more about how and when this is set in section 7 of the [yellow paper](https://ethereum.github.io/yellowpaper/paper.pdf).
* The `^` character in the third gate is a bitwise operation (XOR), and is used here to apply another common bitwise operation (see [here](https://solidity.readthedocs.io/en/v0.4.23/miscellaneous.html#cheatsheet)). The Coin Flip level is also a good place to start when approaching this challenge.

```javascript
pragma solidity ^0.4.18;

contract GatekeeperTwo {

  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    uint x;
    assembly { x := extcodesize(caller) }
    require(x == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
    require(uint64(keccak256(msg.sender)) ^ uint64(_gateKey) == uint64(0) - 1);
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}
```

Let's see, `gateOne` is the same as last level, nothing else.

`gateThree` just XOR the input message with `msg.sender` address, the result should be `uint(0)-1`.

This could be easily solved by XOR `msg.sender` address (which means the contract address you deployed) with `uint64(0)-1`, the result `_gateKey` should be qualified for `gateThree`. 

Most interesting part in this challenge is the `gateTwo`, which require `msg.sender`'s contract code size remain as zreo.

In yellow paper remind in hint:
![](https://i.imgur.com/1JaoZrJ.png)

When contract still in initialization stage, the length of everything we wrote in construct will be reguard as **zero** by `solidity`.

So, let's write our payload in our contract's construct, and simply XOR out the gateKey we needed.

```javascript
pragma solidity ^0.4.18;

contract GatekeeperTwo {

  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    uint x;
    assembly { x := extcodesize(caller) }
    require(x == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
    require(uint64(keccak256(msg.sender)) ^ uint64(_gateKey) == uint64(0) - 1);
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}

contract Empty{
    function Empty(address param) public{
        GatekeeperTwo notThatEmpty = GatekeeperTwo(param);
        bytes8 _gateKey =bytes8((uint64(0) - 1) ^ uint64(keccak256(this)));
        notThatEmpty.enter(_gateKey);
    }
}
```

Deploy the contract with target instance's address as parameter.

```javascript
await contract.entrant()
```

Check the state, this might work.