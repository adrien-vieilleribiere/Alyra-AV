pragma solidity 0.8.18;

// SPDX-License-Identifier: GPL-3.0
interface DataFeed {
    function getData(address token) external returns (uint256 value);
}

contract ErrorManagment {
    DataFeed feed;
    uint256 errorCount;

    function rate(address token) public returns (uint256 value, bool success) {
        // Permanently disable the mechanism if there are
        // more than 10 errors.
        require(errorCount < 10);
        try feed.getData(token) returns (uint256 v) {
            return (v, true);
        } catch Error(
            string memory /*reason*/
        ) {
            // This is executed in case
            // revert was called inside getData
            // and a reason string was provided.
            errorCount++;
            return (0, false);
        } catch (
            bytes memory /*lowLevelData*/
        ) {
            // This is executed in case revert() was used
            // or there was a failing assertion, division
            // by zero, etc. inside getData.
            errorCount++;
            return (0, false);
        }
    }

    function sendHalf(address payable addr)
        public
        payable
        returns (uint256 balance)
    {
        require(msg.value % 2 == 0, "Even value required.");
        uint256 balanceBeforeTransfer = address(this).balance;
        addr.transfer(msg.value / 2);
        // Since transfer throws an exception on failure and
        // cannot call back here, there should be no way for us to
        // still have half of the money.
        assert(address(this).balance == balanceBeforeTransfer - msg.value / 2);
        return address(this).balance;
    }

    function revertExample(uint256 amount) public payable {
        if (amount > msg.value / 2 ether) revert("Not enough Ether provided.");
        // Alternative way to do it:
        require(amount <= msg.value / 2 ether, "Not enough Ether provided.");
        // Perform the purchase.
    }
}

contract SimpleAuction {
    event HighestBidIncreased(address bidder, uint256 amount); // Event

    function bid() public payable {
        // ...
        emit HighestBidIncreased(msg.sender, msg.value); // Triggering event
    }
}
