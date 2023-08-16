// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract DynamicMemory {
    function fetchDynamicMemArrayData(
        uint256[] memory _dynamicArr, // each element will take a 32 byte memory slot
        uint256 memSlot // each slots is 32 bytes long
    ) public pure returns (bytes32 storedVal, bytes32 nextFreeMemLoc) {
        require(_dynamicArr.length != 0, "No data");
        assembly {
            storedVal := mload(mul(memSlot, 0x20))
            nextFreeMemLoc := mload(0x40)
        }
    }
}
