// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {IAlienFactory} from "./Common.sol";

contract AlienFactory is IAlienFactory {
    // Slot 0: _parent (160 bits) + _hasNose (1 bit) + _color (3 bits) + _planet (3 bits) + eyes/legs/arms/antenna (10 bits each) + _height (34 bits) + _age (15 bits) = 256 bits
    uint256 internal _slot0;

    function setAlienAttributes(
        address parent,
        uint256 eyesNumber,
        uint256 legsNumber,
        uint256 armsNumber,
        uint256 antennaNumber,
        bool hasNose,
        uint256 height,
        Color color,
        uint256 age,
        Planet planet
    ) external {
        // < instead of <= save 6 gas
        require(eyesNumber < 1001);
        require(legsNumber < 1001);
        require(armsNumber < 1001);
        require(antennaNumber < 1001);
        require(height < 1e10 + 1);
        require(age < 2e4 + 1);

        assembly {
            // Pack everything into slot 0:
            // _parent (0-159) + _hasNose (160) + _color (161-163) + _planet (164-166) + eyes (167-176) + legs (177-186) + arms (187-196) + antenna (197-206) + height (207-240) + age (241-255)
            let packed := parent
            packed := or(packed, shl(160, hasNose))
            packed := or(packed, shl(161, color))
            packed := or(packed, shl(164, planet))
            packed := or(packed, shl(167, eyesNumber))
            packed := or(packed, shl(177, legsNumber))
            packed := or(packed, shl(187, armsNumber))
            packed := or(packed, shl(197, antennaNumber))
            packed := or(packed, shl(207, height))
            packed := or(packed, shl(241, age))
            sstore(0, packed)
        }
    }

    function getAlienAttributes()
        external
        view
        returns (
            address parent,
            uint256 eyesNumber,
            uint256 legsNumber,
            uint256 armsNumber,
            uint256 antennaNumber,
            bool hasNose,
            uint256 height,
            Color color,
            uint256 age,
            Planet planet
        )
    {
        assembly {
            // Unpack slot 0:
            // _parent (0-159) + _hasNose (160) + _color (161-163) + _planet (164-166) + eyes (167-176) + legs (177-186) + arms (187-196) + antenna (197-206) + height (207-240) + age (241-255)
            let packed := sload(0)
            parent := and(packed, 0xffffffffffffffffffffffffffffffffffffffff)
            hasNose := and(shr(160, packed), 0x1)
            color := and(shr(161, packed), 0x7)
            planet := and(shr(164, packed), 0x7)
            eyesNumber := and(shr(167, packed), 0x3ff)
            legsNumber := and(shr(177, packed), 0x3ff)
            armsNumber := and(shr(187, packed), 0x3ff)
            antennaNumber := and(shr(197, packed), 0x3ff)
            height := and(shr(207, packed), 0x3ffffffff)
            age := and(shr(241, packed), 0x7fff)
        }
    }
}
