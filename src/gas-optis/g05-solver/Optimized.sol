// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {GuessTheNumber, ISolver} from "./Common.sol";

contract Solver is ISolver {
    function solve(GuessTheNumber game) external returns (uint256) {
        uint256 min;
        uint256 max = type(uint256).max;
        do {
            uint256 middle;
            unchecked {
                middle = min + ((max - min) >> 1);
            }
            try this.cheat(game, middle) {}
            catch Error(string memory err) {
                assembly {
                    switch mload(add(err, 32))
                    case 1 {
                        // GREATER: min = middle + 1
                        min := add(middle, 1)
                    }
                    case 0 {
                        // LESS: max = middle - 1
                        max := sub(middle, 1)
                    }
                    default {
                        // EQUAL: return middle
                        mstore(0x00, middle)
                        return(0x00, 0x20)
                    }
                }
            }
        } while (min < max);
        return min;
    }

    function cheat(GuessTheNumber game, uint256 guess) external {
        revert(string(abi.encode(game.guess(guess))));
    }
}
