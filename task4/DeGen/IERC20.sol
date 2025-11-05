// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol"; // 补充导入接口

/**
 * @dev ERC20 Permit 扩展的实现，允许通过签名进行批准（EIP-2612）
 */
contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
    mapping(address => uint256) private _nonces;

    bytes32 private constant _PERMIT_TYPEHASH =
        keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");

    /**
     * @dev 初始化 EIP712 的 name 以及 ERC20 的 name 和 symbol
     */
    constructor(string memory name, string memory symbol) EIP712(name, "1") ERC20(name, symbol) {}

    /**
     * @dev 实现 EIP-2612 的 permit 方法，通过签名授权
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public virtual override {
        require(block.timestamp <= deadline, "ERC20Permit: expired deadline");

        // 先获取当前 nonce（未递增）
        uint256 currentNonce = _nonces[owner];
        // 计算结构体哈希（使用当前 nonce）
        bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, currentNonce, deadline));
        bytes32 hash = _hashTypedDataV4(structHash);
        
        // 验证签名
        address signer = ECDSA.recover(hash, v, r, s);
        require(signer == owner, "ERC20Permit: invalid signature");
        
        // 递增 nonce（消费当前 nonce）
        _nonces[owner] = currentNonce + 1;
        // 执行授权
        _approve(owner, spender, value);
    }

    /**
     * @dev 获取地址当前的 nonce
     */
    function nonces(address owner) public view virtual override returns (uint256) {
        return _nonces[owner];
    }

    /**
     * @dev 返回 EIP-712 的 DOMAIN_SEPARATOR
     */
    function DOMAIN_SEPARATOR() external view override returns (bytes32) {
        return _domainSeparatorV4();
    }
}