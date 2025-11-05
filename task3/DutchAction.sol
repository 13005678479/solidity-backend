// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/access/Ownable.sol";
import "https://github.com/AmazingAng/WTF-Solidity/blob/main/34_ERC721/ERC721.sol";

// 注意：继承顺序应将更基础的合约放在前面
contract DutchAuction is ERC721, Ownable {
    uint256 public constant COLLECTION_SIZE = 10000; // NFT总数
    uint256 public constant AUCTION_START_PRICE = 1 ether; // 起拍价(最高价)
    uint256 public constant AUCTION_END_PRICE = 0.1 ether; // 结束价(最低价/地板价)
    uint256 public constant AUCTION_TIME = 10 minutes; // 拍卖时间
    uint256 public constant AUCTION_DROP_INTERVAL = 1 minutes; // 价格衰减间隔
    uint256 public constant AUCTION_DROP_PER_STEP =
        (AUCTION_START_PRICE - AUCTION_END_PRICE) /
        (AUCTION_TIME / AUCTION_DROP_INTERVAL); // 每次衰减步长
    
    uint256 public auctionStartTime; // 拍卖开始时间戳
    string private _baseTokenURI;   // metadata URI
    uint256[] private _allTokens; // 记录所有存在的tokenId 

    // 构造函数：初始化ERC721和Ownable
    constructor() ERC721("WTF Dutch Auction", "WTFDA") Ownable(msg.sender) {
        auctionStartTime = block.timestamp;
    }

    // 设置拍卖开始时间 (onlyOwner)
    function setAuctionStartTime(uint256 timestamp) external onlyOwner {
        auctionStartTime = timestamp;
    }

    // 获取拍卖实时价格
    function getAuctionPrice() public view returns (uint256) {
        if (block.timestamp < auctionStartTime) {
            return AUCTION_START_PRICE;
        } else if (block.timestamp - auctionStartTime >= AUCTION_TIME) {
            return AUCTION_END_PRICE;
        } else {
            uint256 steps = (block.timestamp - auctionStartTime) / AUCTION_DROP_INTERVAL;
            return AUCTION_START_PRICE - (steps * AUCTION_DROP_PER_STEP);
        }
    }

    // 拍卖 mint 函数
    function auctionMint(uint256 quantity) external payable nonReentrant {
        uint256 _saleStartTime = auctionStartTime;
        require(_saleStartTime != 0 && block.timestamp >= _saleStartTime, "Sale not started");
        require(totalSupply() + quantity <= COLLECTION_SIZE, "Exceeds collection size");

        uint256 totalCost = getAuctionPrice() * quantity;
        require(msg.value >= totalCost, "Insufficient ETH sent");
        
        // Mint NFT
        for (uint256 i = 0; i < quantity; i++) {
            uint256 mintIndex = totalSupply();
            _mint(msg.sender, mintIndex);
            _addTokenToAllTokensEnumeration(mintIndex);
        }

        // 多余ETH退款 (使用call防止重入风险)
        if (msg.value > totalCost) {
            uint256 refund = msg.value - totalCost;
            (bool success, ) = payable(msg.sender).call{value: refund}("");
            require(success, "Refund failed");
        }
    }

    // 提款函数 (onlyOwner)
    function withdrawMoney() external onlyOwner nonReentrant {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Withdrawal failed");
    }

    // 实现ERC721所需的_baseURI函数
    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    // 设置BaseURI (onlyOwner)
    function setBaseURI(string calldata baseURI) external onlyOwner {
        _baseTokenURI = baseURI;
    }

    // 实现_allTokens数组管理函数
    function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
        _allTokens.push(tokenId);
    }

    // 获取所有token总数
    function totalSupply() public view returns (uint256) {
        return _allTokens.length;
    }

    // 防止重入修饰符
    modifier nonReentrant() {
        _;
        // 简单的重入保护（实际生产环境建议使用OpenZeppelin的ReentrancyGuard）
        uint256 guard = 1;
        assembly {
            let slot := guard
            let value := sload(slot)
            if eq(value, 1) {
                revert(0, 0)
            }
            sstore(slot, 1)
        }
    }
}