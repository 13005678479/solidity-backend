// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract RandomNumberConsumer is VRFConsumerBaseV2 {
    // VRF协调器接口
    VRFCoordinatorV2Interface public immutable COORDINATOR;
    
    // 订阅ID
    uint64 public immutable subId;

    // 存储请求ID和随机数
    uint256 public requestId;
    uint256[] public randomWords;
    
    // Sepolia测试网参数
    address public constant VRF_COORDINATOR = 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625;
    bytes32 public constant KEY_HASH = 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c;
    uint16 public constant REQUEST_CONFIRMATIONS = 3; // 建议生产环境使用12
    uint32 public constant CALLBACK_GAS_LIMIT = 200_000;
    uint32 public constant NUM_WORDS = 3; // 一次请求的随机数数量
    
    // 随机数接收事件
    event RandomWordsReceived(uint256 requestId, uint256[] randomWords);
    // 随机数请求事件
    event RandomWordsRequested(uint256 requestId);
    
    constructor(uint64 s_subId) VRFConsumerBaseV2(VRF_COORDINATOR) {
        COORDINATOR = VRFCoordinatorV2Interface(VRF_COORDINATOR);
        subId = s_subId;
    }
    
    /**
     * 请求随机数
     * 注意：调用前需要确保订阅ID有足够的LINK余额
     */
    function requestRandomWords() external returns (uint256) {
        // 调用VRF协调器请求随机数
        requestId = COORDINATOR.requestRandomWords(
            KEY_HASH,
            subId,
            REQUEST_CONFIRMATIONS,
            CALLBACK_GAS_LIMIT,
            NUM_WORDS
        );
        
        emit RandomWordsRequested(requestId);
        return requestId;
    }
    
    /**
     * VRF回调函数，接收随机数
     * 此函数会被VRF协调器自动调用
     */
    function fulfillRandomWords(
        uint256 /* requestId */,
        uint256[] memory s_randomWords
    ) internal override {
        randomWords = s_randomWords;
        emit RandomWordsReceived(requestId, s_randomWords);
    }
}