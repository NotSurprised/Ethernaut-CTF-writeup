# Recovery

A contract creator has built a very simple token factory contract. Anyone can create new tokens with ease. After deploying the first token contract, the creator sent 0.5 ether to obtain more tokens. They have since lost the contract address.
This level will be completed if you can recover (or remove) the `0.5` ether from the lost contract address.

```javascript
pragma solidity ^0.4.23;

contract Recovery {

  //generate tokens
  function generateToken(string _name, uint256 _initialSupply) public {
    new SimpleToken(_name, msg.sender, _initialSupply);
  
  }
}

contract SimpleToken {

  // public variables
  string public name;
  mapping (address => uint) public balances;

  // constructor
  constructor(string _name, address _creator, uint256 _initialSupply) public {
    name = _name;
    balances[_creator] = _initialSupply;
  }

  // collect ether in return for tokens
  function() public payable {
    balances[msg.sender] = msg.value*10;
  }

  // allow transfers of tokens
  function transfer(address _to, uint _amount) public { 
    require(balances[msg.sender] >= _amount);
    balances[msg.sender] -= _amount;
    balances[_to] = _amount;
  }

  // clean up after ourselves
  function destroy(address _to) public {
    selfdestruct(_to);
  }
}
```

This level said that, someone deploy this token factory contract called `Recovery`, with new `SimpleToken` contract declared, victim try to send some ether to `SimpleToken` then make `SimpleToken`'s fallback function increase balances for sender: `balances[msg.sender] = msg.value*10`.

Then, by statement from challenge, victim miss new contract `SimpleToken` address both his ether.

There's tricky problem when a contract deploy another contract.

From [YellowPaper](https://ethereum.github.io/yellowpaper/paper.pdf) chapter 7:
![](https://i.imgur.com/GoubqYo.png)

No doubt that new contract's address deploy by smart contract can be preditable.

![](https://i.imgur.com/YDTVMqZ.png)

By definition of `nonce`, new `SimpleToken`'s address must compute with nonce `1`.

We can use python to compute the address by official [document](https://github.com/ethereum/wiki/wiki/RLP):
```python
def rlp_encode(input):
    if isinstance(input,str):
        if len(input) == 1 and ord(input) < 0x80: return input
        else: return encode_length(len(input), 0x80) + input
    elif isinstance(input,list):
        output = ''
        for item in input: output += rlp_encode(item)
        return encode_length(len(output), 0xc0) + output

def encode_length(L,offset):
    if L < 56:
         return chr(L + offset)
    elif L < 256**8:
         BL = to_binary(L)
         return chr(len(BL) + offset + 55) + BL
    else:
         raise Exception("input too long")

def to_binary(x):
    if x == 0:
        return ''
    else: 
        return to_binary(int(x / 256)) + chr(x % 256)

print rlp_encode(["33542b607f1ded567bde1a52a8c504bf922228ee".decode('hex'),"01".decode('hex')]).encode('hex')  
'''your instance address without 0x hex mark'''
```

```bash
$python main.py
d69433542b607f1ded567bde1a52a8c504bf922228ee01
```

![](https://i.imgur.com/emkwkJg.png)

Then use Remix IDE to get the address back:
```javascript
pragma solidity ^0.4.18;
contract rlp2sha3{
    function func() view returns (address){
        return address(keccak256(0xd69433542b607f1ded567bde1a52a8c504bf922228ee01));
    }
}
```

```
> 0x2626907d71219cbe26538a9b5eC161d29F72dd06
```

![](https://i.imgur.com/b6YuZYX.png)

Or simply search the [open source information](https://ropsten.etherscan.io/) on blockchain about instance address:

![](https://i.imgur.com/tWJIIVx.png)

We found: https://ropsten.etherscan.io/address/0x33542b607f1ded567bde1a52a8c504bf922228ee#internaltx
![](https://i.imgur.com/pv3Mb3E.png)

After level (`0xde038a41cad4236c2b32a5ff1002c61a0cc424a0`) deploy instance (`0x33542b607f1ded567bde1a52a8c504bf922228ee`), instance deploy `SimpleToken` contract on preditable address, `0x2626907d71219cbe26538a9b5eC161d29F72dd06`.

In `SimpleToken` contract (`0x2626907d71219cbe26538a9b5eC161d29F72dd06`), you can see there's a transaction from level (`0xde038a41cad4236c2b32a5ff1002c61a0cc424a0`) which send `0.5` ether to this contract.

![](https://i.imgur.com/T9cMBXU.png)

All fit the statement from challenge.

Our mission is to deploy same contract on that address to interact with it (contract not match will not work), then run the `destroy()` to `selfdestruct()` the contract:
![](https://i.imgur.com/4d6KU2q.png)

Check the contract destructed ready or not:
https://ropsten.etherscan.io/address/0x2626907d71219cbe26538a9b5ec161d29f72dd06#internaltx
![](https://i.imgur.com/i9aaFZS.png)
