pragma solidity 0.8.18;

// SPDX-License-Identifier: GPL-3.0

contract Time {
    function getTime() public view returns uint {
        return block.timestamp;
    }
}
