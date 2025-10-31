// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

//3、✅  用 solidity 实现整数转罗马数字
contract IntToRoman {
    // 整数转罗马数字函数
    function intToRoman(uint num) public pure returns (string memory)  {
    // 定义罗马数字对应的数值（从大到小排列）
            uint[] memory values = new uint[](13);
            values[0] = 1000;
            values[1] = 900;
            values[2] = 500;
            values[3] = 400;
            values[4] = 100;
            values[5] = 90;
            values[6] = 50;
            values[7] = 40;
            values[8] = 10;
            values[9] = 9;
            values[10] = 5;
            values[11] = 4;
            values[12] = 1;

            // 对应的罗马数字符号（与values顺序一一对应）
            string[] memory symbols = new string[](13);
            symbols[0] = "M";
            symbols[1] = "CM";
            symbols[2] = "D";
            symbols[3] = "CD";
            symbols[4] = "C";
            symbols[5] = "XC";
            symbols[6] = "L";
            symbols[7] = "XL";
            symbols[8] = "X";
            symbols[9] = "IX";
            symbols[10] = "V";
            symbols[11] = "IV";
            symbols[12] = "I";

            // 存储结果的bytes（用于高效拼接字符串拼接）
            bytes memory result = new bytes(0);
             // 贪心算法：从最大的数值开始匹配
             for (uint i =0;i<values.length;i++) 
             {
                 // 当当前数值小于等于剩余数字时，拼接对应的符号符号并减去对应数值
                 while (num >= values[i]) {
                    result = abi.encodePacked(result, symbols[i]);
                     num -= values[i];
                 }
                   // 数字减为0时提前退出
                  if (num == 0) break;
             }
             return string(result);
    }
    
}