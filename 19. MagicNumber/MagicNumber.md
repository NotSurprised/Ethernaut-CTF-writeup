# MagicNumber
To solve this level, you only need to provide the Ethernaut with a "Solver", a contract that responds to "whatIsTheMeaningOfLife()" with the right number.
Easy right? Well... there's a catch.
The solver's code needs to be really tiny. Really reaaaaaallly tiny. Like freakin' really really itty-bitty tiny: 10 opcodes at most.
Hint: Perhaps its time to leave the comfort of the Solidity compiler momentarily, and build this one by hand O_o. That's right: Raw EVM bytecode.
Good luck!

```javascript
pragma solidity ^0.4.24;

contract MagicNum {

  address public solver;

  constructor() public {}

  function setSolver(address _solver) public {
    solver = _solver;
  }

  /*
    ____________/\\\_______/\\\\\\\\\_____        
     __________/\\\\\_____/\\\///////\\\___       
      ________/\\\/\\\____\///______\//\\\__      
       ______/\\\/\/\\\______________/\\\/___     
        ____/\\\/__\/\\\___________/\\\//_____    
         __/\\\\\\\\\\\\\\\\_____/\\\//________   
          _\///////////\\\//____/\\\/___________  
           ___________\/\\\_____/\\\\\\\\\\\\\\\_ 
            ___________\///_____\///////////////__
  */
}
```

From some reference:
https://blog.zeppelin.solutions/deconstructing-a-solidity-contract-part-i-introduction-832efd2d7737
https://medium.com/coinmonks/ethernaut-lvl-19-magicnumber-walkthrough-how-to-deploy-contracts-using-raw-assembly-opcodes-c50edb0f71a2

To solve this level, you need 2 sets of opcodes:
* `Initialization opcodes`: to be run immediately by the EVM to create your contract and store your future runtime opcodes, and
* `Runtime opcodes`: to contain the actual execution logic you want. This is the main part of your code that should return 0x42 and be under 10 opcodes.

Returning values is handled by the RETURN opcode, which takes in two arguments:
* `p`: the position where your value is stored in memory, i.e. 0x0, 0x40, 0x50 (see figure). Let’s arbitrarily pick the 0x80 slot.
* `s`: the size of your stored data. Recall your value is 32 bytes long (or 0x20 in hex).

![](https://i.imgur.com/g062nQV.png)
Every Ethereum transaction has 2²⁵⁶ bytes of (temporary) memory space to work with.

Let's search the opcode list for `push`, `malloc`, `return`.
(Accroding to Etheremn memory space, it doesn't implement the method of `MOV` value to register and swap to stack or heap like x86 or ARM.)

Here's Etheremn opcode list:
https://ethervm.io/
https://github.com/ethereum/pyethereum/blob/develop/ethereum/opcodes.py


| opcode | hex |
| -------- | -------- |
|push|`x60`|
|mstore|`x52`|
|return|`f3`|

Then we got a draft for runtime opcode:
* mstore(p, v) -> push v, push p, mstore
```
6042    // v: push1 0x42 (value is 0x42)
6080    // p: push1 0x80 (memory slot is 0x80)
52      // mstore
```
* return(p, s) -> push s, push p, return
```
6020    // s: push1 0x20 (value is 32 bytes in size)
6080    // p: push1 0x80 (value was stored in slot 0x80)
f3      // return
```

Just choose the position in memory wherever you want.

Now let’s create the contract `initialization opcodes`. These opcodes need to replicate your `runtime opcodes` to memory, before returning them to the EVM. Recall that the EVM will then automatically save the runtime sequence `604260805260206080f3` to the blockchain, you won’t have to handle this last part.

Copying code from one place to another is handled by the opcode codecopy, which takes in 3 arguments:

* `t`: the destination position of the code, in memory. Let’s arbitrarily save the code to the `0x00` position.
* `f`: the current position of the `runtime opcodes`, in reference to the entire bytecode. Remember that f starts after initialization opcodes end. What a chicken and egg problem! This value is currently unknown to you.
* `s`: size of the code, in bytes. Recall that 604260805260206080f3 is 10 bytes long (or `0x0a` in hex).

First, fill up the opcode which will copy `runtime opcodes` into memory.
```
600a    // s: push1 0x0a (10 bytes)
60??    // f: push1 0x?? (current position of runtime opcodes)
6000    // t: push1 0x00 (destination memory index 0)
39      // CODECOPY
```

Then, `return` your in-memory `runtime opcodes` to the EVM.
```
600a    // s: push1 0x0a (runtime opcode length)
6000    // p: push1 0x00 (access memory index 0)
f3      // return to EVM
```

Let's now calculate the `f`:
```
600a    // s: push1 0x0a (10 bytes)
60??    // f: push1 0x?? (current position of runtime opcodes)
6000    // t: push1 0x00 (destination memory index 0)
39      // CODECOPY
600a    // s: push1 0x0a (runtime opcode length)
6000    // p: push1 0x00 (access memory index 0)
f3      // return to EVM
```

`initialization opcodes` here take 12 bytes, which means `f` should be `0x0c`.

So, the final result of `initialization opcodes` + `runtime opcodes` will be `0x600a600c600039600a6000f3604260805260206080f3`.

With `MetaMask` plugin, in browser console:
```javascript
var account = "your address here";
var bytecode = "0x600a600c600039600a6000f3602a60005260206000f3";
await web3.eth.sendTransaction({ from: account, data: bytecode }, function(err,res){console.log(res)});
```

Remember to edit the gas fee for your transaction.

![](https://i.imgur.com/HxRygIa.png)

My new contract address is `0x18f60ee7b9ff82652f8fa0c9ef6b0daba6731803`.

Just let your ethernaut instance's `setSolver()` to call your new contract.

```javascript
await contract.setSolver("0x742b873eea24a2ff9472e991ad1c57f400d218ab")
```

Then check if `solver` valuable exactly changed before you submit it.

```javascript
await contract.solver()
```
## Method 2
```javascript
pragma solidity ^0.4.24;

contract MagicNumSolver {
  constructor() public {
    assembly {

      // This is the bytecode we want the program to have:
      // 00 PUSH1 2a /* push dec 42 (hex 0x2a) onto the stack */
      // 03 PUSH1  0 /* store 42 at memory position 0 */
      // 05 MSTORE
      // 06 PUSH1 20 /* return 32 bytes in memory */
      // 08 PUSH1 0
      // 10 RETURN
      // Bytecode: 0x604260005260206000f3 (length 0x0a or 10)
      // Bytecode within a 32 byte word:
      // 0x00000000000000000000000000000000000000000000604260005260206000f3 (length 0x20 or 32)
      //                                               ^ (offset 0x16 or 22)
      
      mstore(0, 0x602a60005260206000f3)
      return(0x16, 0x0a)
    }
  }
}
```

## Method 3
```javascript
pragma solidity ^0.4.24;

contract MagicNumBadSolver {
    
  function whatIsTheMeaningOfLife() public pure returns (bytes32) {
    return 42;
  }
}
```

Method 2 must has opcode number greater than 10, but still work though.

---
Here come up a question that how level call `whatIsTheMeaningOfLife()` then our contract just return value `42` without being called any function.

I will modified this writeup, if I find out the reason.