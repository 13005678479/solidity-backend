// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract ReciveEvent {

    // 定义事件
    event Received(address sender,uint value);

    event fallbackCalled(address Sender, uint Value, bytes Data);

    receive() external payable { 
         emit Received(msg.sender, msg.value);
    }

    fallback() external payable {
        emit  fallbackCalled(msg.sender,msg.value,msg.data);
    }

}