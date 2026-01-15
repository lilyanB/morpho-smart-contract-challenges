// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ILoops} from "./Common.sol";

contract Loops is ILoops {
    function loop1(uint256[] calldata array) external pure returns (uint256 result) {
        uint256 len = array.length;
        if (len == 0) {
            return result;
        }
        uint256 i;
        do {
            result += array[i];
            unchecked {
                ++i;
            }
        } while (i < len);
    }

    function loop2(uint256[10] calldata array) external pure returns (uint256 result) {
        uint256 i;
        do {
            result += array[i];
            unchecked {
                ++i;
            }
        } while (i < 10);
    }

    function loop3(uint256[] calldata array) external pure returns (uint256 result) {
        uint256 len = array.length;
        require(len <= 10);
        uint256 i;
        do {
            result += array[i];
            unchecked {
                ++i;
            }
        } while (i < len);
    }
}
