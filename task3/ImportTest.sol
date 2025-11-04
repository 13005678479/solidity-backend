// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import './Yeye.sol';

contract Import {

     // 声明yeye变量
    Yeye yeye = new Yeye();
    // 测试是否能调用yeye的函数
    function test() external{
        yeye.hip();
    }


}