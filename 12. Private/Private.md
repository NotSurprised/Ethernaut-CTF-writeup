# Private

Let's first start at challenge info:

The creator of this contract was careful enough to protect the sensitive areas of its storage.
Unlock this contract to beat the level.
Things that might help:
* Understanding how storage works
* Understanding how parameter parsing works
* Understanding how casting works

Tips:
* Remember that metamask is just a commodity. Use another tool if it is presenting problems. Advanced gameplay could involve using remix, or your own web3 provider.

```javascript
pragma solidity ^0.4.18;

contract Privacy {

  bool public locked = true;
  uint256 public constant ID = block.timestamp;
  uint8 private flattening = 10;
  uint8 private denomination = 255;
  uint16 private awkwardness = uint16(now);
  bytes32[3] private data;

  function Privacy(bytes32[3] _data) public {
    data = _data;
  }
  
  function unlock(bytes16 _key) public {
    require(_key == bytes16(data[2]));
    locked = false;
  }

  /*
    A bunch of super advanced solidity algorithms...

      ,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`
      .,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,
      *.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^         ,---/V\
      `*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.    ~|__(o.o)
      ^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'  UU  UU
  */
}
```

```javascript
> web3Provider = new Web3.providers.HttpProvider('https://ropsten.infura.io/');
> web3 = new Web3(web3Provider);
> web3.eth.getStorageAt(contract.address, 0)
< "0x00000000000000000000000000000000000000000000000000000011c6ff0a01"
> web3.eth.getStorageAt(contract.address, 1)
< "0x67dc893f034b9469e561561209d48f538e06c0a56beaeeb8d4d5aa8c8f9ad467"
> web3.eth.getStorageAt(contract.address, 2)
< "0x722be78596650c1ea8f8e74d7ea118305c75651115f4277afed5f2f486f9e6a3"
> web3.eth.getStorageAt(contract.address, 3)
< "0x7c8826cea6098e4eafaaede1d3325e8b49e3df1bf9d747fc090cbc67c9b35b81"
> web3.eth.getStorageAt(contract.address, 4)
< "0x0000000000000000000000000000000000000000000000000000000000000000"
```

Cuz to constant variable will not store on block which cost gas, all variable we got in block storage will skip `uint256 public constant ID`.

Additonally, Solidity will optimize storage algorithm with that every variable not reach to 32 bytes will append follwed variable if the sum does not exceed 32 byte, also.

Therefore, `65cdff0a01` must be consisted of following components :
bool true -> `01`
uint8 10 -> `0a`
uint8 255 -> `ff`
uint16 now -> `65cd`

Then `getStorageAt` 1, 2, 3 will match to `data[0]`, `data[1]`, `data[2]`.

Worth to note that, `bytes16(data[2])` will change `data[2]` from 32 bytes to 16 bytes.

Let's take a pretest on it, `bytes16` will drop rest byte from 17th byte to 32th byte on storage.

So the key will be `web3.toAscii('0x7c8826cea6098e4eafaaede1d3325e8b')`

```javascript
await contract.unlock(web3.toAscii('0x7c8826cea6098e4eafaaede1d3325e8b'))
await contract.locked
```