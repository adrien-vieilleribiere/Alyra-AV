pragma solidity 0.8.18;

// SPDX-License-Identifier: GPL-3.0

contract Bank {
    mapping(address => uint256) private balances;
    event Deposit(address _address, uint256 _amount);
    event Transfert(address _addressFrom, address _addressTo, uint256 _amount);

    function deposit(uint256 _amount) public payable {
        require(msg.sender.balance > _amount, "insufficient funds");
        balances[msg.sender] += _amount;
        emit Deposit(msg.sender, _amount);
    }

    function transfer(address _recipient, uint256 _amount) public {
        require(_recipient != address(0), "token destruction is not allowed");
        require(balances[msg.sender] >= _amount, "insufficient funds");
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
        emit Transfert(msg.sender, _recipient, _amount);
    }

    function balanceOf(address _address) public view returns (uint256) {
        return balances[_address];
    }
}
