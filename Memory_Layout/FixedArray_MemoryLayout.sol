// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract FixedArrMemLayout {
    // fixed length memory array has similar layout to that of structs
    function manipulateMemArray() external pure {
        uint8[2] memory arr = [1, 2];

        assembly {
            pop(mload(0x80)) // returns 0x0000...000001 (32 bytes)
            pop(mload(0xa0)) // returns 0x0000...000002 (32 bytes)
        }
    }
}
