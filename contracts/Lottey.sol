// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

contract Lottery {
    address public manager;
    address [] public players;

    constructor() {
      manager = msg.sender;

    }


    function enter() payable public {
        require(msg.value >= 0.01 ether, "Please enter more than 0.01 Ether");
        players.push(msg.sender);
    }

    function pickWinner()  public {
        require(msg.sender == manager, "ONLY manager");
        uint index = random() % players.length; //ขนาดของ players array
        (bool success,) = players[index].call{value: (address(this).balance)}("");
        require(success, "Transfer failed");
        players = new address [](0);  // clear array of players
    }

    function random() private view returns (uint) {
        // คืนค่า เลขสุ่มที่เกิดจากสูตรด้านล่าง ซึ่งมีการใช้วันเวลาของ block  -- ตัวแปร global variable 
        return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, players)));

    }
}