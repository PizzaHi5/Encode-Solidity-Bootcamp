// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/** @notice Since we are auditing this, I am adding my additions as notes in this contract
 */
contract DogCoinGame is ERC20 {
    /// @dev currentPrize is not used anywhere
    uint256 public currentPrize;
    uint256 public numberPlayers;
    /// @dev consider using mappings and removing winners to save on gas
    address payable[] public players;
    address payable[] public winners;

    event startPayout();

    constructor() ERC20("DogCoin", "DOG") {}

    function addPlayer(address payable _player) public payable {
        /** @dev It stated that the intent is to require 1 ether to be input
                however 1 here refers to 1 wei. It costs 1 wei to play atm, 
                use 1 x 10^18 or specify 1 ether
            */
        if (msg.value == 1) {
            players.push(_player);
        }
        numberPlayers++;

        /** @dev This requires 201 players to begin execution, not 200.
         */
        if (numberPlayers > 200) {
            emit startPayout();
        }
    }

    /** @dev Instead of storing all winners to an array, it would be
            cheaper to read using a mapping(uint => address) or better
            yet, use the players array again to save on storage cost. 
     */
    function addWinner(address payable _winner) public {
        winners.push(_winner);
    }

    /** @dev Consider limiting access to this function.
            Anyone with an ether balance of over 100 ether 
            would be able to call this function.
    */
    function payout() public {
        /// @dev same note as above, denote as 100 ether
        if (address(this).balance == 100) {
            /** @dev Since there are 100 winner selected, consider that 
                    the amount paid back will be the same as the amount
                    sent in. 100 / 100 = 1
            */
            uint256 amountToPay = winners.length / 100;
            payWinners(amountToPay);
        }
    }

    /// @dev Consider adding an access restriction here, anyone can call payWinner atm
    /// @dev You will want this function payable to send ether
    function payWinners(uint256 _amount) public {
        /** @dev Consider using transfer instead of send, refer to:
                https://docs.soliditylang.org/en/v0.8.17/units-and-global-variables.html#members-of-address-types
         */
        for (uint256 i = 0; i <= winners.length; i++) {
            winners[i].send(_amount);
        }
    }

    /** Consider adding a access restricted function to recieve the ether stored on this contract
     */
}