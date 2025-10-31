// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

//2、✅ 反转字符串 (Reverse String)
//题目描述：反转一个字符串。输入 "abcde"，输出 "edcba"

contract StringReverser {

     // 反转字符串函数：输入字符串，返回反转后的字符串
     function reverseString(string memory _str) public pure returns (string memory) {
        // 将字符串转换为bytes数组（便于按索引操作字符）
        bytes memory strBytes = bytes(_str);
        // 计算字符串长度（字节数）
        uint length = strBytes.length;
         // 双指针反转：左指针从0开始，右指针从最后一位开始
         for (uint left = 0; left < length / 2; left++) 
         {
             uint right = length - 1 - left;
              // 交换左右指针位置的字符
            (strBytes[left], strBytes[right]) = (strBytes[right], strBytes[left]);
         }
        // 将bytes数组转回字符串并返回
        return string(strBytes);
     } 
}