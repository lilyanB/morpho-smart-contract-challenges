// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {GuessTheNumber2, ISolver2} from "./Common.sol";

contract Solver2 is ISolver2 {
    function solve(GuessTheNumber2 game) external returns (uint256) {
        // version 1 to analyse and display byte code:
        // uint256 value;
        // assembly {
        //     // from "https://docs.soliditylang.org/en/latest/assembly.html#example"
        //     // retrieve the size of the code, this needs assembly
        //     let size := extcodesize(game)
        //     // allocate output byte array - this could also be done without assembly
        //     // by using code = new bytes(size)
        //     let code := mload(0x40)
        //     // new "memory end" including padding
        //     mstore(0x40, add(code, and(add(add(size, 0x20), 0x1f), not(0x1f))))
        //     // store length in memory
        //     mstore(code, size)
        //     // actually retrieve the code, this needs assembly
        //     extcodecopy(game, add(code, 0x20), 0, sub(size, 160)) // we skip the last 160 bytes

        //     // we can see all the bytecode of the contract and analyze it to find 2 push32. These push32
        //     // correspond to the 2 immutables used during the "guess" function.

        //     let codePtr := add(code, 0x20)
        //     let codeLen := mload(code)

        //     // scan through the bytecode by checking each 32-byte sequence
        //     for { let i := 0 } lt(i, sub(codeLen, 32)) { i := add(i, 1) } {
        //         let byteVal := byte(0, mload(add(codePtr, i)))
        //         // if we find a PUSH32 opcode (0x7f)
        //         if eq(byteVal, 0x7f) {
        //             // retrieve the next 32 bytes as the immutable value
        //             value := mload(add(codePtr, add(i, 1)))
        //             break
        //         }
        //     }
        // }
        // return value;

        // version 2
        assembly {
            extcodecopy(game, 0, 154, 32)
            return(0, 32)
        }
    }
}
