// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.17;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Storage.sol";

contract TestStorage {
    function testItStoresAValue() public {
        Storage simpleStorage = Storage(DeployedAddresses.Storage());
        simpleStorage.store(89);
        uint256 expected = 89;
        Assert.equal(
            simpleStorage.retrieve(),
            expected,
            "It should store the value 89."
        );
    }
}
