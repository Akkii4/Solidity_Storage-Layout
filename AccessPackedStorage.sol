// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract AccessPackedStorage {
    // State variables
    uint256 x = 32; // slot 0

    address user = address(20); // slot 1 offset 0
    uint64 y = 8; // slot 1, offset 20
    uint8 j = 1; // slot 1 offset 28
    uint24 k = 3; // slot 1 offset 29

    uint128 z = 16; // slot 2

    // Read from storage slots
    function getVarFromSlot(uint256 slot) external view returns (bytes32 val) {
        assembly {
            val := sload(slot)
        }
    }

    // example showing extracting value stored at variable j
    function accessValFromPackedSlot()
        external
        view
        returns (bytes32 valStartingAtOffset, bytes32 extractedVal)
    {
        assembly {
            // full value stored at the slot where j is stored(slot 1)
            // 0x0000030100000000000000080000000000000000000000000000000000000014
            let storedValAtSlot := sload(j.slot)

            // right shifts 28 bytes(j offset) the stored Value
            // 0x0000000000000000000000000000000000000000000000000000000000000301
            valStartingAtOffset := shr(mul(j.offset, 8), storedValAtSlot)

            // to extract only the value of the desired variable
            // bitwise and operation with same number of 1 bits(f in hex) as the variable length of variable
            // 0x0000000000000000000000000000000000000000000000000000000000000001
            extractedVal := and(0xff, valStartingAtOffset)
        }
    }
}
