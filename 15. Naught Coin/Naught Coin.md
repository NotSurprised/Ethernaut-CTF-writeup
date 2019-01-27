# Naught Coin

NaughtCoin is an ERC20 token and you're already holding all of them. The catch is that you'll only be able to transfer them after a 10 year lockout period. Can you figure out how to get them out to another address so that you can transfer them freely? Complete this level by getting your token balance to 0.
  Things that might help
* The [ERC20](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md) Spec
* The [OpenZeppelin](https://github.com/OpenZeppelin/openzeppelin-solidity/tree/master/contracts) codebase


```javascript
pragma solidity ^0.4.18;

import 'https://github.com/syncikin/zeppelin-solidity/contracts/token/ERC20/StandardToken.sol';

contract NaughtCoin is StandardToken {

    string public constant name = 'NaughtCoin';
    string public constant symbol = '0x0';
    uint public constant decimals = 18;
    uint public timeLock = now + 10 years;
    uint public INITIAL_SUPPLY = 1000000 * (10 ** decimals);
    address public player;

    function NaughtCoin(address _player) public {
        player = _player;
        totalSupply_ = INITIAL_SUPPLY;
        balances[player] = INITIAL_SUPPLY;
        Transfer(0x0, player, INITIAL_SUPPLY);
    }

    function transfer(address _to, uint256 _value) lockTokens public returns(bool) {
        super.transfer(_to, _value);
    }

    // Prevent the initial owner from transferring tokens until the timelock has passed
    modifier lockTokens() {
        if (msg.sender == player) {
            require(now > timeLock);
            if (now < timeLock) {
                _;
            }
        } else {
            _;
        }
    } 
}
```

There's modifier which rewrite the `tranfer` function that make us cannot withdraw the balance immediately.

Fortunately, this contract import and inherit a parent class, let's find anotherway to make us bypass the time lock.

https://github.com/syncikin/zeppelin-solidity/blob/master/contracts/token/ERC20/StandardToken.sol

```javascript
function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[_from]);
    require(_value <= allowed[_from][msg.sender]);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
    Transfer(_from, _to, _value);
    return true;
}
function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
}
function allowance(address _owner, address _spender) public view returns (uint256) {
    return allowed[_owner][_spender];
}
```

In `transferFrom()` we can see there's requirement about `require(_value <= allowed[_from][msg.sender])`.

In `NaughtCoin` contract, we know that **Ethernaut** dployed the contract with ` 1000000 * (10 ** decimals)` wei in our account: `balances[player] = INITIAL_SUPPLY;`.

So, we can use `approve()` function to set a spender for our account in `NaughtCoin` contract.

However, due to `allowed[msg.sender][_spender] = _value;` require `msg.sender` equal to `account address` in `NaughtCoin` contract, you can not deploy a contract to resolve it, otherwise, you need to find out a method that deploy a contract on your player address.

After we successfully approve the spender for our `player`'s balances account, just simply `transderFrom()` to another `NaughtCoin` contract to make acoount balance decrease into 0.

First, deploy a 3rd_contract to accept the transaction.
```javascript
pragma solidity ^0.4.18;

import 'https://github.com/syncikin/zeppelin-solidity/contracts/token/ERC20/StandardToken.sol';

contract NaughtCoin is StandardToken {

    string public constant name = 'NaughtCoin';
    string public constant symbol = '0x0';
    uint public constant decimals = 18;
    uint public timeLock = now + 10 years;
    uint public INITIAL_SUPPLY = 1000000 * (10 ** decimals);
    address public player;

    function NaughtCoin(address _player) public {
        player = _player;
        totalSupply_ = INITIAL_SUPPLY;
        balances[player] = INITIAL_SUPPLY;
        Transfer(0x0, player, INITIAL_SUPPLY);
    }

    function transfer(address _to, uint256 _value) lockTokens public returns(bool) {
        super.transfer(_to, _value);
    }

    // Prevent the initial owner from transferring tokens until the timelock has passed
    modifier lockTokens() {
        if (msg.sender == player) {
            require(now > timeLock);
            if (now < timeLock) {
                _;
            }
        } else {
            _;
        }
    } 
}
```

Then, interact with level contract on web console(`msg.sender` might be your player address):
```javascript
await contract.allowance(player,player)
await contract.approve(player, (await contract.INITIAL_SUPPLY()).toNumber())
await contract.transferFrom(player, [_3rd_contract_address], (await contract.INITIAL_SUPPLY()).toNumber())
await contract.allowance(player,player)
```