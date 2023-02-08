pragma solidity 0.8.18;

// SPDX-License-Identifier: GPL-3.0

contract Random {
    uint256 private nonce;

    function random() public returns (uint256) {
        nonce++;
        return 100 % 100;
        // uint256(
        //     keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))
        // ) % 100;
    }
}
