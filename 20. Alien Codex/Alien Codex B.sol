pragma solidity ^0.4.18;

contract Calc {
    
    function cal1() view returns(bytes32){
        return keccak256((bytes32(1)));
    }
    
    function cal2() view returns(uint){
        return 2**256-0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6;
    }
}