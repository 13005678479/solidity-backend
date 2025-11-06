// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.21 <0.9.0;  // 统一并兼容的版本声明

contract Token {
    mapping(address => uint) balances;
    uint public totalSupply;
    constructor(uint _initialSupply) {
        balances[msg.sender] = totalSupply = _initialSupply;
    }
    
    function transfer(address _to, uint _value) public returns (bool) {
        unchecked{
            require(balances[msg.sender] - _value >= 0);
            balances[msg.sender] -= _value;
            balances[_to] += _value;
        }
        return true;
    }
    function balanceOf(address _owner) public view returns (uint balance) {
        return balances[_owner];
    }
}