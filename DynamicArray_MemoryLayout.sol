// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract DynamicMemory {
    /**
    * Layout in Memory(Reserves certain areas of memory) :
        - First 64 bytes (0x00 to 0x3f) used for storing temporarily data while performing hash calculations
        - Next 32 bytes (0x40 to 0x5f) also known as "free memory pointer" keeps track of next available location in memory where new data can be stored
        - Next 32 bytes (0x60 to 0x7f) is a zero slot that is used as starting point for dynamic memory arrays that is initialized with 0 and should never be written to.
    */
    function fetchDynamicMemArrayData(
        uint256[] memory _dynamicArr, // each element will take a memory slot
        uint256 memSlot // each slots is 32 bytes long
    ) public pure returns (bytes32 storedVal, bytes32 nextFreeMemLoc) {
        require(_dynamicArr.length != 0, "No data");
        assembly {
            storedVal := mload(mul(memSlot, 0x20))
            nextFreeMemLoc := mload(0x40)
        }
    }

    function exceedMemoryGasLimit() public pure returns (uint256 storedVal) {
        assembly {
            storedVal := mload(mul(110000, 0x20))
        }
    }
}
