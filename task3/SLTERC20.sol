// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;
import "./ERC20.sol";

/**
 * @title ERC20 基础代币合约
 * @dev 实现 ERC20 代币的核心功能
 */
contract SLTERC20 is ERC20 {

  // 记录已领取代币的地址
    mapping(address => bool) public requestedAddress;
    // 每次领取的代币数量
    uint256 public constant amountAllowed = 100 * 10 **18; // 100代币（考虑18位小数）
    // 发送代币事件
    event SendToken(address indexed recipient, uint256 amount);

    constructor() ERC20("My Token", "MTK") {
        // 初始化时铸造一些代币到合约地址作为水龙头资金
        _mint(address(this), 20 * 10** 18); // 铸造20个代币到合约
    }

    // 领取代币的函数
    function requestToken() external {
        require(!requestedAddress[msg.sender], "Can't Request Multiple Times!"); // 每个地址只能领一次
        // 直接调用父类的transfer函数（因为当前合约继承了ERC20，本身就是ERC20代币合约）
        transfer(msg.sender, amountAllowed); 
        requestedAddress[msg.sender] = true; // 记录领取地址 
        emit SendToken(msg.sender, amountAllowed); // 释放SendToken事件
    }
}