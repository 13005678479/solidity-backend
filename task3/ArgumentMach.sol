// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract ArgumentMach {

    function f (uint8 _in) public pure returns (uint8 out)  {
        out = _in;
    }

    function f (uint256 _in) public pure returns (uint256 out)  {
        out = _in;
    }

}