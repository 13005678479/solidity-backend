// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract TransforOwner {

    // 声明存储代币所有者的映射（tokenId => 所有者地址）
    mapping(uint256 => address) private _owners;

    error TransferNotOwner(); // 自定义error
    // error TransferNotOwner(address sender); // 自定义的带参数的error

    // 在执行当中，error必须搭配revert（回退）命令使用。
    function transferOwner1(uint256 tokenId, address newOwner) public {
    if(_owners[tokenId] != msg.sender){
        revert TransferNotOwner();
        // revert TransferNotOwner(msg.sender);
        }
        _owners[tokenId] = newOwner;
    }

    function transferOwner3(uint256 tokenId, address newOwner) public {
        assert(_owners[tokenId] == msg.sender);
        _owners[tokenId] = newOwner;
    }

    function transferOwner2(uint256 tokenId, address newOwner) public {
        require(_owners[tokenId] == msg.sender, "Transfer Not Owner");
        _owners[tokenId] = newOwner;
    }
}