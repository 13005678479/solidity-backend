// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BinarySearch {
    // 在有序数组（升序）中查找目标值，返回索引（未找到返回 -1）
    function search(uint[] calldata nums, uint target) public pure returns (int) {
        uint left = 0;
        uint right = nums.length - 1;
        
        // 边界条件：空数组直接返回 -1
        if (nums.length == 0) {
            return -1;
        }
        
        // 二分查找循环：左指针 <= 右指针
        while (left <= right) {
            // 计算中间索引（避免溢出：等价于 (left + right) / 2，但更安全）
            uint mid = left + (right - left) / 2;
            
            if (nums[mid] == target) {
                // 找到目标值，返回索引（转为 int 以兼容 -1）
                return int(mid);
            } else if (nums[mid] < target) {
                // 中间值小于目标值，缩小左边界
                left = mid + 1;
            } else {
                // 中间值大于目标值，缩小右边界
                right = mid - 1;
            }
        }
        
        // 循环结束仍未找到，返回 -1
        return -1;
    }
}