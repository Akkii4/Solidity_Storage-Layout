// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// Because objects in memory are laid out end to end, arrays have no push unlike storage
// it's because in storage the values of dynamic array start being stored from the hash of there storage slot,
// while its not possible in case of memory(due to expansion gas cost) and linearly it can crash into other elements slots
contract DynamicMemory {
    function fetchDynamicMemArrayData(
        uint256[] memory _dynamicArr, // each element will take a 32 byte memory slot
        uint256 memSlot // each slots is 32 bytes long
    ) public pure returns (bytes32 storedVal, bytes32 nextFreeMemLoc) {
        require(_dynamicArr.length != 0, "No data");
        assembly {
            // starting from initial free mem ptr (0x80) the dynamic array length will be stored,
            // and thereafter each of array elements taking 32 bytes slots
            storedVal := mload(mul(memSlot, 0x20))
            nextFreeMemLoc := mload(0x40)
        }
    }
}
