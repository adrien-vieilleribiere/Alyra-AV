// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.18;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract SimpleStorageWithDonation is Ownable {
    uint256 data;

    event Log(string message);
    event Log(uint256 val);
    event Log(bool val);

    constructor(uint256 _initSet) payable {
        set(_initSet);
        if (msg.value > 0) {
            require(msg.value > 1, "vous navez pas envoye assez");
        }
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function set(uint256 x) public {
        data = x;
    }

    function get() public view returns (uint256) {
        return data;
    }

    function modifyAndLog(uint256 val) public {
        emit Log(data);
        set(val);
        emit Log(get());
    }

    function sendMoneyToOwner() public onlyOwner {
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 1, "balance is not enought");
        require(owner() != address(0), "balance is not enought");
        (bool passed, ) = owner().call{value: contractBalance}("");
        require(passed, "fail to transfert");
    }
}
