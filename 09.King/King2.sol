pragma solidity ^0.4.18;

contract dosKing {
    function dosKing(address param) public payable{
        param.call.gas(10000000).value(msg.value)();
    }
}