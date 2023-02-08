// ERC20Token.sol
// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "./ERC20token.sol";

contract Crowdsale {
    uint256 public rate = 200; // le taux à utiliser
    ERC20Token public token;

    constructor(uint256 initialSupply) {
        token = new ERC20Token(initialSupply);
    }
}
