// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract SelectContract {

    // event 返回msg.data
    event Log(bytes data);

    function mint(address to) external{
        emit Log(msg.data);
    }

    function mintSelector() external pure returns(bytes4 mSelector){
        return bytes4(keccak256("mint(address)"));
    }

}