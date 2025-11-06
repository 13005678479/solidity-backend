// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.21 <0.9.0;  // 统一并兼容的版本声明

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Centralization is ERC20, Ownable {
    // 构造函数：移除重复的 SPDX 和版本声明，统一继承链
    constructor() ERC20("Centralization", "Cent") Ownable(msg.sender) {
        address exposedAccount = 0xe16C1623c1AA7D919cd2241d8b36d9E79C1Be2A2;
        // 检查地址有效性（避免设置无效地址为 owner）
        require(exposedAccount != address(0), "Invalid owner address");
        transferOwnership(exposedAccount);
    }

    // 仅所有者可调用的 mint 函数
    function mint(address to, uint256 amount) external onlyOwner {
        require(to != address(0), "Mint to zero address");  // 防止向零地址 mint
        require(amount > 0, "Mint amount must be positive");  // 防止 mint 零值
        _mint(to, amount);
    }
}