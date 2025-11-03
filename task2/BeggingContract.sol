// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

/**
 * @title BeggingContract
 * @dev 一个简单的讨饭合约，允许用户捐赠以太币，记录捐赠信息，并允许所有者提取资金
 * 核心功能：接收捐赠、记录捐赠、查询捐赠、提取资金
 */
contract BeggingContract  {

    /**
     * @dev 合约所有者地址（不可变，部署后无法修改）
     * 用于限制提款功能只能由合约创建者调用
     */
    address private immutable owner;

    /**
     * @dev 捐赠记录映射：地址 => 捐赠总金额（以wei为单位）
     * 存储每个地址的累计捐赠额，支持重复捐赠（金额会累加）
     */
    mapping(address => uint256) private donations;

    /**
     * @dev 捐赠事件，每次成功捐赠后触发
     * @param donor 捐赠者地址（使用indexed便于后续过滤查询）
     * @param amount 捐赠金额（以wei为单位）
     * 事件会被永久记录在区块链上，可通过前端或工具查询历史捐赠记录
     */
    event Donation(address indexed donor, uint256 amount);

    /**
     * @dev 仅所有者可调用的修饰符
     * 用于限制敏感操作（如提款）只能由合约所有者执行
     * 验证失败时会回滚交易并返回错误信息
     */
    modifier onlyOwner() {
        // 检查调用者是否为合约所有者
        require(msg.sender == owner, "BeggingContract: only owner can call this function");
        // _ 表示执行被修饰的函数体
        _;
    }

    /**
     * @dev 合约构造函数，部署时自动执行
     * 将合约部署者的地址设置为所有者
     */
    constructor() {
        // msg.sender 是当前交易的发起者（即部署合约的地址）
        owner = msg.sender;
    }

    /**
     * @dev 捐赠函数，允许用户向合约发送以太币
     * @notice 调用时需要附带以太币（通过value字段指定）
     * @dev 带有payable修饰符，使函数能够接收以太币
     */
    function donate() external payable {
        // 验证捐赠金额必须大于0（防止恶意或误操作的0金额捐赠）
        require(msg.value > 0, "BeggingContract: donation amount must be greater than 0");
        
        // 更新捐赠记录：将本次捐赠金额累加到捐赠者的总金额中
        // msg.value 是当前交易附带的以太币数量（以wei为单位）
        donations[msg.sender] += msg.value;
        
        // 触发捐赠事件，记录本次捐赠的地址和金额
        emit Donation(msg.sender, msg.value);
    }

     /**
     * @dev 提款函数，允许合约所有者提取合约中的所有资金
     * @notice 仅合约所有者可调用，且合约必须有余额才能提款
     * @dev 使用transfer函数安全转移以太币，失败时会自动回滚
     */
    function withdraw() external onlyOwner {
        // 获取合约当前的以太币余额（以wei为单位）
        uint256 contractBalance = address(this).balance;
        
        // 验证合约余额必须大于0（防止无意义的提款操作）
        require(contractBalance > 0, "BeggingContract: no funds to withdraw");
        
        // 将合约中的所有余额转移给所有者
        // payable(owner) 将所有者地址转换为可接收以太币的地址
        // transfer函数会自动处理gas限制（2300 gas），失败时抛出异常
        payable(owner).transfer(contractBalance);
    }

    /**
     * @dev 查询指定地址的累计捐赠金额
     * @param donor 要查询的捐赠者地址
     * @return 该地址的累计捐赠额（以wei为单位）
     */
    function getDonation(address donor) external view returns (uint256) {
        // 直接返回映射中存储的捐赠金额
        return donations[donor];
    }
    
    /**
     * @dev 查询合约当前的以太币余额
     * @return 合约当前的余额（以wei为单位）
     * @notice 辅助函数，方便查看合约中可提取的资金总量
     */
    function getContractBalance() external view returns (uint256) {
        // address(this) 表示当前合约的地址，.balance获取其以太币余额
        return address(this).balance;
    }
    
    /**
     * @dev 获取合约所有者地址
     * @return 合约所有者的地址
     * @notice 辅助函数，方便验证当前所有者身份
     */
    function getOwner() external view returns (address) {
        return owner;
    }

}