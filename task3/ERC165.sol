// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

interface IERC165 {
    /**
     * @dev 如果合约实现了查询的`interfaceId`，则返回true
     * 规则详见：https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     *
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// 定义IERC721接口（最小化定义，用于获取interfaceId）
interface IERC721 {
    // 仅声明必要的函数以生成正确的interfaceId
    function balanceOf(address owner) external view returns (uint256);
    function ownerOf(uint256 tokenId) external view returns (address);
    function transferFrom(address from, address to, uint256 tokenId) external;
}

contract ERC165 is IERC165{

    /**
     * @dev 实现接口检测功能
     * 支持IERC165自身和IERC721接口
     */
    function supportsInterface(bytes4 interfaceId) external pure override returns (bool) {
        return 
            interfaceId == type(IERC165).interfaceId ||  // 支持IERC165接口
            interfaceId == type(IERC721).interfaceId;   // 支持IERC721接口
    }
    
}