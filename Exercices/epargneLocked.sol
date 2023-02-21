// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.18;

import "@openzeppelin/contracts/access/Ownable.sol";

contract epargne is Ownable {
    //address private owner1;
    uint256 id;
    mapping(uint256 => uint256) public depots;
    uint256 time;

    /* constructor() {
    owner1=msg.sender;
  }

  modifier onlyOwner{
    require(msg.sender==owner1);
    _;
  } */

    function deposit() public payable onlyOwner {
        depots[id] = msg.value;
        if (time == 0) {
            time = block.timestamp + 12 weeks;
        }
        id++;
    }

    function retraits() public onlyOwner {
        require(address(this).balance >= 1, "rien a retirer");
        require(block.timestamp >= time, "t'as pas attendu assez");
        (bool sent, ) = payable(msg.sender).call{value: address(this).balance}(
            ""
        );
        require(sent, unicode"transfert non effectué");
    }

    receive() external payable {
        deposit();
    }
}
