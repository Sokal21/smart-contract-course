// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract SimpleStorage {
    struct People {
        uint256 age;
        string name;
    }

    People[] public persons;

    function store(uint256 age, string calldata name) public {
        persons.push(People({age: age, name: name}));
    }
}
// 0xd9145CCE52D386f254917e481eB44e9943F39138
