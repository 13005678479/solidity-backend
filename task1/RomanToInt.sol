// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract RomanToInt {
       // 将映射定义为合约状态变量（存储在storage中）
    mapping(bytes1 => uint) private romanMap;
        // 构造函数：初始化罗马字符与数值的映射关系
    constructor() {
        romanMap['I'] = 1;
        romanMap['V'] = 5;
        romanMap['X'] = 10;
        romanMap['L'] = 50;
        romanMap['C'] = 100;
        romanMap['D'] = 500;
        romanMap['M'] = 1000;
    }

     // 罗马数字转整数函数
    function romanToInt(string calldata s) public view returns (uint) {
        bytes memory romanBytes = bytes(s);
        uint length = romanBytes.length;
        uint result = 0;

        for (uint i = 0; i < length; i++) {
            uint current = romanMap[romanBytes[i]];
            // 左减规则：当前值 < 下一个值时，减去当前值
            if (i < length - 1 && current < romanMap[romanBytes[i + 1]]) {
                result -= current;
            } else {
                result += current;
            }
        }

        return result;
    }

}