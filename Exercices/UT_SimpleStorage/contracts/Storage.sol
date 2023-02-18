// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.17;

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 * @custom:dev-run-script ./scripts/deploy_with_ethers.ts grgr
 */
contract Storage {
    uint256 public number;

    event NormalEvent(uint256 eventParamValue);

    /**
     * @dev Store value in variable
     * @param num value to store
     */
    function store(uint256 num) public {
        number = num;
    }

    /**
     * @dev Return value
     * @return value of 'number'
     */
    function retrieve() public view returns (uint256) {
        return number;
    }

    function failIfNot42(uint256 num) public pure returns (bool) {
        require(num == 42, "it must be 42");
        return true;
    }

    function emitFakeEvent(uint256 num) public returns (bool) {
        emit NormalEvent(10 + num);
        return true;
    }
}
