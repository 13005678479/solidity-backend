// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

//✅ 创建一个名为Voting的合约，包含以下功能：
//一个mapping来存储候选人的得票数
//一个vote函数，允许用户投票给某个候选人
//一个getVotes函数，返回某个候选人的得票数
//一个resetVotes函数，重置所有候选人的得票数

contract Voting {
     // 存储候选人得票数的mapping（候选人地址 => 得票数）
     mapping (address => uint256) public  candidateVotes;

    // 存储所有已投票的候选人地址，用于重置
     address [] public candidates;

    // 记录候选人是否已在数组中，避免重复添加
    mapping (address => bool) public isCandidate;

      // 投票函数：允许用户给指定候选人投票
      function vote (address candidate) external  {
         // 每次投票给候选人的得票数加1
         candidateVotes[candidate]++;

         // 如果是新的候选人，添加到数组中
         if (!isCandidate[candidate]) {
            candidates.push(candidate);
            isCandidate[candidate] = true;
         }
      }
    // 获取候选人得票数的函数
    function getVotes(address candidate) external view returns ( uint256) {
        return  candidateVotes[candidate];
    }

    // 重置所有候选人得票数的函数
    function resetAllVotes() external {
        // 遍历所有已知的候选人，逐个重置他们的得票数
        for (uint i=0;i<candidates.length;i++) 
        {
            delete candidateVotes[candidates[i]];
        }
        // 清空候选人数组和记录
        delete candidates;
    }

}