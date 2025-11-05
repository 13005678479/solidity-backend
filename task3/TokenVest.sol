// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

contract TokenVesting {
    // 事件
    event ERC20Released(address indexed token, uint256 amount);
    event TokensDeposited(address indexed token, uint256 amount, uint256 totalAllocation);

    // 状态变量
    mapping(address => uint256) public erc20Released;
    address public immutable beneficiary;
    uint256 public immutable start;
    uint256 public immutable duration;
    // 新增：记录每个代币的总分配量（避免重复计算）
    mapping(address => uint256) public totalAllocations;

    /**
     * @dev 初始化受益人地址和释放周期
     */
    constructor(
        address beneficiaryAddress,
        uint256 durationSeconds
    ) {
        require(beneficiaryAddress != address(0), "VestingWallet: beneficiary is zero address");
        require(durationSeconds > 0, "VestingWallet: duration must be positive");
        
        beneficiary = beneficiaryAddress;
        start = block.timestamp;
        duration = durationSeconds;
    }

    /**
     * @dev 存入代币到合约（支持批量存入）
     * 只有受益人可以存入代币，确保分配控制权
     */
    function deposit(address token, uint256 amount) external {
        require(msg.sender == beneficiary, "Only beneficiary can deposit");
        require(token != address(0), "Invalid token address");
        require(amount > 0, "Amount must be positive");

        // 转移代币到合约
        bool success = IERC20(token).transferFrom(msg.sender, address(this), amount);
        require(success, "Token transfer failed");

        // 更新总分配量
        totalAllocations[token] += amount;
        emit TokensDeposited(token, amount, totalAllocations[token]);
    }

    /**
     * @dev 受益人提取已释放的代币
     */
    function release(address token) public {
        require(msg.sender == beneficiary, "Only beneficiary can release");
        require(token != address(0), "Invalid token address");

        uint256 releasable = vestedAmount(token, block.timestamp) - erc20Released[token];
        require(releasable > 0, "No tokens available to release");

        erc20Released[token] += releasable;
        emit ERC20Released(token, releasable);

        bool success = IERC20(token).transfer(beneficiary, releasable);
        require(success, "Token release failed");
    }

    /**
     * @dev 计算指定时间点可释放的代币数量
     */
    function vestedAmount(address token, uint256 timestamp) public view returns (uint256) {
        uint256 totalAllocation = totalAllocations[token];
        if (totalAllocation == 0) return 0;

        if (timestamp < start) {
            return 0;
        } else if (timestamp >= start + duration) {
            return totalAllocation;
        } else {
            // 线性释放计算
            return (totalAllocation * (timestamp - start)) / duration;
        }
    }

    /**
     * @dev 计算当前可提取的代币数量
     */
    function releasableAmount(address token) public view returns (uint256) {
        return vestedAmount(token, block.timestamp) - erc20Released[token];
    }
}