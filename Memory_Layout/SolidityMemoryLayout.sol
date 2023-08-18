// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract SolidityMemoryLayout {
    /**
    * Layout in Memory(Reserves certain areas of memory) :
        - First 64 bytes (0x00 to 0x3f) used for storing temporarily data while performing hash calculations
        - Next 32 bytes (0x40 to 0x5f) also known as "free memory pointer" keeps track of next available location in memory where new data can be stored
        - Next 32 bytes (0x60 to 0x7f) is a zero slot that is used as starting point for dynamic memory arrays that is initialized with 0 and should never be written to.
    */
    function freeMemory() external {
        assembly {
            // fetches the next free available slots in the memory
            let freeMemPtr := mload(0x40)

            // Free memory pointer is auto. managed by the solidity but need to manually update while using Yul
            mstore(freeMemPtr, 1)
            mstore(add(freeMemPtr, 0x20), 2) // adds 32 bytes to the freeMemPtr offset and then stores the new value
            mstore(add(freeMemPtr, 0x40), 3) // similarly here we leaps 2 slots(one for the previous and one for this) and then stores the value
            mstore8(add(freeMemPtr, 0x48), 4) // can read memory in 32 bytes while writing can be in 8 or 32 bytes

            // mstore(offset ,4) : 0x0000000000000000000000000000000000000000000000000000000000000004
            // mstore8(offset,4) : 0x0400000000000000000000000000000000000000000000000000000000000000

            // update the free memory pointer by the length already occupied 3 slots + 8 bytes = 0x68
            updateFreeMemPtr(0x68)

            // updates free memory pointer that gets the occupied slots length of the memory added as input
            function updateFreeMemPtr(length) {
                let previousFreeMemPtr := mload(0x40)
                mstore(0x40, add(previousFreeMemPtr, length))
            }

            // msize : returns the largest accessed memory index
            // msize does not guarantee unused memory until the free pointer is updated
        }
    }

    // if at any point in code execution free mem ptr is mishandled it can cause overwrite
    function breakFreeMemoryPointer(
        uint256[1] memory foo
    ) external view returns (uint256) {
        // initially foo element is stored at 0x80
        assembly {
            mstore(0x40, 0x80) // mishandling free mem ptr
        }
        uint256[1] memory bar = [uint256(6)]; // overwrites foo at 0x80
        return foo[0];
    }

    uint8[] foo = [1, 2, 3, 4, 5, 6]; // here array element are packed into 1 (32 bytes) storage slot

    function unpacked() external view {
        uint8[] memory bar = foo; // loading from storage to memory , automatically unpacks the elements
        assembly {
            pop(mload(0x80)) //  0x0000...000006 (length of array)
            pop(mload(0xa0)) //   0x0000...000001
            pop(mload(0xc0)) //   0x0000...000002
            pop(mload(0xe0)) //   0x0000...000003
            //...
            pop(mload(0x140)) //   0x0000...000006
        }
    }

    /**
     * Memory Expansion costs : EVM doesn't allocate the entire memory upfront.
     *  It expands as needed, and cost gas only for the expansion.
     * memory_size_word = (memory_byte_size + 31) / 32
     * memory_cost = (memory_size_word ** 2) / 512 + (3 * memory_size_word)
     * memory_expansion_cost = new_memory_cost - last_memory_cost
     */
    function exceedMemoryGasLimit() public pure returns (uint256 storedVal) {
        assembly {
            storedVal := mload(mul(125000, 0x20)) // gives Out of gas error once we hit 30MN Ethereum Block gas limit
        }
        // for memory_size_word ~= 123200 bytes, 30MN gas limit will reach
    }
}
