// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Library, Shelf, Book, ISearchEngine} from "./Common.sol";

contract SearchEngine is ISearchEngine {
    function search(Library lib, bytes32 author, bytes32 name) external view returns (bytes32) {
        assembly {
            // shelves(bytes32)
            // -----------------------------------------------
            // 1. Signature : "shelves(bytes32)"
            // 3. keccak256("shelves(bytes32)") =
            //    0x0e97c429cf9a7c91a0118b89ca4f8f6c41cadf392db1c31fb882b59af43db77f
            // 4. First 4 bytes = 0x0e97c429
            // 5. Add the author argument after the first 4 bytes
            // 6. author use 32 bytes
            // 7. Total size = 4 + 32 = 36 bytes = 0x24
            // 8. We will store the output in memory position 0x00
            // 9. The output size is 32 bytes = 0x20
            // -----------------------------------------------
            mstore(0x00, 0x0e97c429cf9a7c91a0118b89ca4f8f6c41cadf392db1c31fb882b59af43db77f)
            mstore(0x04, author)
            if iszero(staticcall(gas(), lib, 0x00, 0x24, 0x00, 0x20)) { revert(0, 0) }
            let shelf := mload(0x00)

            // books(bytes32)
            // -----------------------------------------------
            // 1. Signature : "books(bytes32)"
            // 3. keccak256("books(bytes32)") =
            //    0x0c0dee703c5c18a02a770676e4d1d5bbbfd35c1cb1d766090f05049f906042b0
            // 4. First 4 bytes = 0x0c0dee70
            // 5. Add the name argument after the first 4 bytes
            // 6. name use 32 bytes
            // 7. Total size = 4 + 32 = 36 bytes = 0x24
            // 8. We will store the output in memory position 0x00
            // 9. The output size is 32 bytes = 0x20
            // -----------------------------------------------
            mstore(0x00, 0x0c0dee703c5c18a02a770676e4d1d5bbbfd35c1cb1d766090f05049f906042b0)
            mstore(0x04, name)
            if iszero(staticcall(gas(), shelf, 0x00, 0x24, 0x00, 0x20)) { revert(0, 0) }
            let book := mload(0x00)

            // content()
            // -----------------------------------------------
            // 1. Signature : "content()"
            // 3. keccak256("content()") =
            //    0x8a4d5a67f8489fa92791d06ecc53a4cbf0af1e4943d24569cd0ab319ae5e4479
            // 4. First 4 bytes = 0x8a4d5a67
            // 5. No arguments
            // 6. Total size = 4 bytes = 0x04
            // 7. We will store the output in memory position 0x00
            // 8. The output size is 32 bytes = 0x20
            // -----------------------------------------------
            mstore(0x00, 0x8a4d5a67f8489fa92791d06ecc53a4cbf0af1e4943d24569cd0ab319ae5e4479)
            if iszero(staticcall(gas(), book, 0x00, 0x04, 0x00, 0x20)) {
                revert(0, 0)
            }
            return(0x00, 0x20)
        }
    }
}
