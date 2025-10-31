// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MergeSortedArrays {
    // 合并两个有序数组（升序），返回合并后的有序数组
    function merge(uint[] calldata nums1, uint[] calldata nums2) public pure returns (uint[] memory) {
        uint len1 = nums1.length;
        uint len2 = nums2.length;
        // 结果数组长度为两个数组长度之和
        uint[] memory result = new uint[](len1 + len2);
        
        uint i = 0; // nums1 的指针
        uint j = 0; // nums2 的指针
        uint k = 0; // 结果数组的指针
        
        // 双指针遍历两个数组，按顺序放入结果数组
        while (i < len1 && j < len2) {
            if (nums1[i] <= nums2[j]) {
                result[k] = nums1[i];
                i++;
            } else {
                result[k] = nums2[j];
                j++;
            }
            k++;
        }
        
        // 处理 nums1 剩余元素
        while (i < len1) {
            result[k] = nums1[i];
            i++;
            k++;
        }
        
        // 处理 nums2 剩余元素
        while (j < len2) {
            result[k] = nums2[j];
            j++;
            k++;
        }
        
        return result;
    }
}