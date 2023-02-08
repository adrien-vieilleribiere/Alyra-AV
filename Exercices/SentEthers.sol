pragma solidity 0.8.18;

// SPDX-License-Identifier: GPL-3.0

contract exoAV {
    address public ad;

    function setAdress(address _address) public {
        ad = _address;
    }

    function getMainBalance() public view returns (uint256) {
        return ad.balance;
    }

    function getBalance(address _address) public view returns (uint256) {
        return _address.balance;
    }

    function sendMoney(address _add) public payable returns (bool) {
        (bool ok, ) = _add.call{value: msg.value}("");
        return ok;
    }

    function transferEthcheck(uint256 _bal) public payable returns (bool) {
        require(msg.value > 1, "vous navez pas envoye assez");
        require(getBalance(msg.sender) > _bal, "vous ne pouvez pas envoyer");
        (bool passed, ) = ad.call{value: _bal}("");
        return passed;
    }
}
