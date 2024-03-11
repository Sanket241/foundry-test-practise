// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.2;

import {Test,console} from "forge-std/Test.sol";
import {Lottery} from "../src/Lottery.sol";


contract LotteryTest is Test{

   Lottery public lottery;
   address public manager = makeAddr("manager");// change string to address
    address public player1 = makeAddr("player1");
    address payable[] public players;


   function setUp() public{
        vm.startPrank(manager);
        lottery = new Lottery();
        vm.stopPrank();
    }

    modifier EnterPlayers() {
        address player2 = makeAddr("player2");
        address player3 = makeAddr("player3");
        address player4 = makeAddr("player4");
        address player5 = makeAddr("player5");
        // players.push(payable(player1));
        // players.push(payable(player2));
        // players.push(payable(player3));
        players.push(payable(player4));
        players.push(payable(player5));
        
        for(uint i=0;i<players.length; ++i){
            vm.startPrank(players[i]);
            vm.deal(players[i], 2 ether);// add fund
            (bool success, ) = address(lottery).call{value: 2 ether}("");
            vm.stopPrank();
        }
        _;
    }

    function testGetBalance() public{
        vm.startPrank(manager);
        uint balance = lottery.getBalance();
        vm.stopPrank();
        console.log("Balance ",balance);
        assertEq(balance,0);
    }
    function testGetBalanceAterEnterPlayers() public EnterPlayers {
        vm.startPrank(manager);
        uint balance = lottery.getBalance();
        vm.stopPrank();
        console.log("Balance ",balance);
        assertEq(balance, 10 ether);
    }

    function testGetBalanceCallerIsOnlyManager() public {
        vm.expectRevert(); //require test manager
        vm.startPrank(player1);
        lottery.getBalance();
        vm.stopPrank();
    }
    // constructor testing starting

    function testConstructor() public {
        assertEq(lottery.manager(), manager); // no need to write vm.prank because this is a public function
    }

    function testRandom() public {
        vm.expectRevert();
        vm.startPrank(player1);
        lottery.random();
        vm.stopPrank();
    }

    function testRandomyoy() public EnterPlayers {
        vm.startPrank(manager);
        uint rr = lottery.random();

        uint rrr = uint(keccak256(abi.encodePacked(block.prevrandao,block.timestamp,players)));

        assertEq(rr, rrr);
        vm.stopPrank();
    }

    function testRequireInPickWinner() public {
        vm.expectRevert(); //require test manager
        vm.startPrank(player1);
        lottery.pickWinner();
        vm.stopPrank();
    }
    function testpickWinnerLessThan3Players() public {
        vm.expectRevert(); //require test manager
        vm.startPrank(manager);
        lottery.pickWinner();
        vm.stopPrank();
    }
    function testpickWinnerlwngth() public EnterPlayers {
        vm.startPrank(manager);
        uint index = lottery.random() % players.length;
        address winner = players[index];
        


        vm.stopPrank();
    }

}