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
        players.push(payable(player1));
        players.push(payable(player2));
        players.push(payable(player3));
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
    function testGetBalanceAfterEnterPlayers() public EnterPlayers {
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

    function testReturnRandomAddress(address addr2, address addr3, address addr4, address addr5) public {
        // vm.assume(addr2 != addr3 && addr2 != addr5 && addr2 != addr4 && addr5 != addr3 && addr3 != addr4 && addr4 != addr5 && player1 != addr3 && player1 != addr2 && player1 != addr4 && player1 != addr5);
        address player2 = addr2;
        address player3 = addr3;
        address player4 = addr4;
        address player5 = addr5;
        players.push(payable(player1));
        players.push(payable(player2));
        players.push(payable(player3));
        players.push(payable(player4));
        players.push(payable(player5));
        
        for(uint i=0;i<players.length; ++i){
            vm.startPrank(players[i]);
            vm.deal(players[i], 2 ether);// add fund
            (bool success, ) = address(lottery).call{value: 2 ether}("");
            vm.stopPrank();
        }

        vm.startPrank(manager);
        uint balance = lottery.getBalance();
        uint index = lottery.random() % players.length;
        address winner = players[index];
        lottery.pickWinner();
        address Actualwinner = lottery.previousWinner();
        console.log("winner blance:",winner.balance);

        assertEq(winner.balance, balance);
        assertEq(Actualwinner, winner);
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
    function testpickWinnerLessThan3Players() public EnterPlayers {
        vm.startPrank(manager);
        lottery.pickWinner();
        vm.stopPrank();
    }
    function testpickWinnerlwngth() public EnterPlayers {
        vm.startPrank(manager);
        uint balance = lottery.getBalance();
        uint index = lottery.random() % players.length;
        address winner = players[index];
        lottery.pickWinner();
        address Actualwinner = lottery.previousWinner();
        console.log("winner blance:",winner.balance);

        assertEq(winner.balance, balance);
        assertEq(Actualwinner, winner);
        vm.stopPrank();
    }

}

// Unit test 
// Intregration test
// Forked test
// Staging test
// Refactoring 1 Testing deploy
// Refactoring 2 helper config
// Refactoring 3 mocking
// CHeatcodes
// Fuzz testing
// Inveriant testing
