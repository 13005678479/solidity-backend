// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// 导入 OpenZeppelin 的 ERC721 标准实现库
// 导入 Ownable 库，用于实现合约所有权控制（仅所有者可执行特定操作）
import "@openzeppelin/contracts/access/Ownable.sol";
// 导入URI存储扩展（用于设置tokenURI）
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

// 定义合约 MyImageNFT，继承 ERC721（NFT 标准功能）和 Ownable（所有权控制）
contract MyImageNFT  is ERC721URIStorage, Ownable {
    // 声明私有变量 _tokenIdCounter，用于记录下一个要铸造的 NFT 的 ID
    // 私有变量只能在当前合约内部访问，增强数据安全性
    uint256 private _tokenIdCounter;

    // 构造函数：部署合约时自动执行，用于初始化 NFT 基本信息
    // ERC721 构造函数需要传入两个参数：NFT 名称（name）和符号（symbol）
    // Ownable(msg.sender) 表示将合约所有权赋予部署者（msg.sender 为部署时调用者地址）
    constructor() ERC721("Jay My Image NFT", "MIMG") Ownable(msg.sender) {
        // 初始化代币 ID 计数器为 1（从 1 开始计数，0 通常留空或作为特殊用途）
        _tokenIdCounter = 1;
    }

    /**
     * @dev 铸造 NFT 并关联元数据的函数
     * @param recipient 接收 NFT 的钱包地址
     * @param tokenURI 指向 IPFS 上元数据 JSON 文件的链接
     * @notice 仅合约所有者可调用此函数（由 onlyOwner 修饰符限制）
     */
    function mintNFT(address recipient, string memory tokenURI) public onlyOwner {
        // 将当前计数器的值赋值给 tokenId，作为本次铸造的 NFT 唯一标识
        uint256 tokenId = _tokenIdCounter;
        // 计数器自增，确保下一次铸造的 NFT 使用新的 ID（避免重复）
        _tokenIdCounter++;
        // 调用 ERC721 库中的 _safeMint 函数安全铸造 NFT
        // _safeMint 会检查接收地址是否支持 ERC721 标准（避免 NFT 发送到无效地址丢失）
        _safeMint(recipient, tokenId);
        // 调用 ERC721 库中的 _setTokenURI 函数，将 NFT 与元数据链接关联
        // 元数据包含 NFT 的图片、描述等信息，是 NFT 可视化的核心
        _setTokenURI(tokenId, tokenURI);
    }
}