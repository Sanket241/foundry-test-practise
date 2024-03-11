// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract Lottery{
    address public manager;
    address payable[] public Lotterist;
    address public previousWinner;

    constructor(){
        manager = msg.sender;
    }
    receive() external payable {
        require(msg.value >= 2 ether);
        Lotterist.push(payable(msg.sender));
    }
    function getBalance() public view returns (uint) {
        require(msg.sender == manager, "You are not authorized body");
        return address(this).balance;
    }
  
    function random() public view returns(uint){  require(msg.sender == manager, "You are not authorized body");
      
        return uint(keccak256(abi.encodePacked(block.prevrandao,block.timestamp,Lotterist)));

    }
    function pickWinner() public payable {
        require(msg.sender == manager,"You are not authorized body");
        require(Lotterist.length >= 3, " There is no any participant");
        uint index = random() % Lotterist.length;
        previousWinner = Lotterist[index];
        payable(previousWinner).transfer(getBalance()); // payable(winner).transfer(address(this).balance);
        Lotterist = new address payable[](0);
    }

    }
    