pragma solidity 0.8.18;
// SPDX-License-Identifier: GPL-3.0
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Admin is Ownable {
    mapping(address => bool) whitelisted;
    mapping(address => bool) blacklisted;

    event Whitelisted(address _address);
    event Blacklisted(address _address);

    function whitelist(address _address) public onlyOwner {
        require(
            !whitelisted[_address],
            "This address is already whitelisted !"
        );
        require(
            !blacklisted[_address],
            "This address is already blacklisted !"
        );
        whitelisted[_address] = true;
        emit Whitelisted(_address);
    }

    function isWhitelisted(address _address)
        public
        view
        onlyOwner
        returns (bool)
    {
        return whitelisted[_address];
    }

    function blacklist(address _address) public onlyOwner {
        require(
            !whitelisted[_address],
            "This address is already whitelisted !"
        );
        require(
            !blacklisted[_address],
            "This address is already blacklisted !"
        );
        blacklisted[_address] = true;
        emit Blacklisted(_address);
    }

    function isBlacklisted(address _address)
        public
        view
        onlyOwner
        returns (bool)
    {
        return whitelisted[_address];
    }

    function renounceOwnership() public virtual override {}
}
