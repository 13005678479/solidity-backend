// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

/**
 * @title ERC20 基础代币合约
 * @dev 实现 ERC20 代币的核心功能
 */
contract ERC20 {
    // 记录每个地址的代币余额
    mapping(address => uint256) public balanceOf;

    // 记录授权额度：owner 授权 spender 花费的代币数量
    mapping(address => mapping(address => uint256)) public allowance;

    // 代币总供应量
    uint256 public totalSupply;

    // 代币名称（如 "MyToken"）
    string public name;

    // 代币符号（如 "MTK"）
    string public symbol;

    // 代币小数位数（默认 18 位，与以太坊一致）
    uint8 public decimals = 18;

    /**
     * @dev 转账事件：当代币从一个地址转移到另一个地址时触发
     * @param from 转出地址
     * @param to 转入地址
     * @param value 转移的代币数量
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev 授权事件：当所有者授权给另一个地址花费代币时触发
     * @param owner 授权者地址
     * @param spender 被授权者地址
     * @param value 授权的代币数量
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev 构造函数：初始化代币名称和符号
     * @param name_ 代币名称
     * @param symbol_ 代币符号
     */
    constructor(string memory name_, string memory symbol_) {
        name = name_;
        symbol = symbol_;
    }

    /**
     * @dev 转账功能：从调用者地址向目标地址转移代币
     * @param to 接收代币的地址
     * @param value 转移的代币数量（以最小单位计）
     * @return 转账成功返回 true
     */
    function transfer(address to, uint256 value) public returns (bool) {
        require(balanceOf[msg.sender] >= value, unicode"ERC20: 余额不足");
        require(to != address(0), unicode"ERC20: 不能转账到零地址");

        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    /**
     * @dev 授权功能：允许 spender 从调用者地址花费指定数量的代币
     * @param spender 被授权的地址
     * @param value 授权的代币数量
     * @return 授权成功返回 true
     */
    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0), unicode"ERC20: 不能授权零地址");

        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    /**
     * @dev 授权转账：从 from 地址向 to 地址转移代币（需先授权）
     * @param from 转出代币的地址
     * @param to 接收代币的地址
     * @param value 转移的代币数量
     * @return 转账成功返回 true
     */
    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public returns (bool) {
        require(allowance[from][msg.sender] >= value, unicode"ERC20: 授权额度不足");
        require(balanceOf[from] >= value, unicode"ERC20: 余额不足");
        require(to != address(0), unicode"ERC20: 不能转账到零地址");

        allowance[from][msg.sender] -= value;
        balanceOf[from] -= value;
        balanceOf[to] += value;
        emit Transfer(from, to, value);
        return true;
    }

    /**
     * @dev 内部函数：铸造代币（增加总供应量并分配给指定地址）
     * @param to 接收铸造代币的地址
     * @param value 铸造的代币数量
     */
    function _mint(address to, uint256 value) internal {
        require(to != address(0), unicode"ERC20: 不能铸造到零地址");

        totalSupply += value;
        balanceOf[to] += value;
        emit Transfer(address(0), to, value);
    }

    /**
     * @dev 内部函数：销毁代币（减少总供应量并从指定地址扣除）
     * @param from 被销毁代币的地址
     * @param value 销毁的代币数量
     */
    function _burn(address from, uint256 value) internal {
        require(from != address(0), unicode"ERC20: 不能从零地址销毁");
        require(balanceOf[from] >= value, unicode"ERC20: 销毁数量超过余额");

        balanceOf[from] -= value;
        totalSupply -= value;
        emit Transfer(from, address(0), value);
    }
}