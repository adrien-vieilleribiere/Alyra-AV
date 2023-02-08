pragma solidity 0.8.18;

// SPDX-License-Identifier: GPL-3.0

contract Loops {
    uint256 data;

    function storeWhile(uint256 num) public {
        uint256 increment = num;
        uint256 limit = 12;
        while (limit > increment) {
            increment += num;
        }
        number = increment;
    }

    function storeDoWhile(uint256 num) public {
        uint256 increment = num;
        uint256 limit = 12;
        do {
            increment += num;
        } while (limit > increment);
        number = increment;
    }

    function storeContinue(uint256 num) public {
        uint256 increment = num;
        uint256 limit = 12;
        for (uint256 i = 0; i < 10; i++) {
            if (limit == increment) {
                increment++;
                continue;
            }
            increment += num;
        }
        number = increment;
    }

    function storeReturn(uint256 num) public returns (uint256) {
        uint256 increment = num;
        uint256 limit = 12;
        for (uint256 i = 0; i < 10; i++) {
            if (limit == increment) {
                return increment;
            }
            increment += num;
        }
        number = increment;
        return number;
    }

    function get() public view returns (uint256) {
        return data;
    }
}
