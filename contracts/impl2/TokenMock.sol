// SPDX-License-Identifier: MIT
pragma solidity 0.6.9;


contract TokenMock {

    string public name;

    constructor(string memory _name) public {
        name = _name;
    }
    
}