pragma solidity 0.8.18;

// SPDX-License-Identifier: GPL-3.0

contract Whitelist {
    mapping(address => bool) whitelist;
    event Authorized(address _address);

    modifier whitelisted() {
        require(whitelist[msg.sender], "Calling adress is not whitelisted.");
        _;
    }

    function check(address _address) private view returns (bool) {
        return whitelist[_address];
    }

    function authorize(address _address) public whitelisted {
        whitelist[_address] = true;
        emit Authorized(_address);
    }
}
