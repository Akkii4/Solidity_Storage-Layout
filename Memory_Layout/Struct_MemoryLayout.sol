// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract StructMemLayout {
    struct S {
        uint256 a;
        uint256 b;
    }

    event MemoryPointerMsize(bytes32 freeMemPtr, bytes32 mSize);

    function manipulateMemStruct() external {
        bytes32 freeMemoryPointer;
        bytes32 _msize;
        assembly {
            freeMemoryPointer := mload(0x40)
            _msize := msize()
        }
        emit MemoryPointerMsize(freeMemoryPointer, _msize); // initially freeMemPtr = 0x80 & msize = 0x60

        S memory s = S({a: 1, b: 2}); //Adding structs to memory is just like adding their values 1 by 1.

        assembly {
            // free memory pointer is now 0x80 + 32 bytes * 2 = 0xc0
            // i.e mload(0x80) will have a:1 & mload(0xa0) will have b:2
            freeMemoryPointer := mload(0x40)
            _msize := msize()
        }
        emit MemoryPointerMsize(freeMemoryPointer, _msize); // freeMemPtr = 0xc0 & msize = 0xc0

        assembly {
            // just reading from a memory slot 0xff (which doesn't exists yet) , memory expansion will happen
            pop(mload(0xff)) // pop here means we are just reading the value and later removing it from stack not storing it anywhere
            _msize := msize()
        }
        emit MemoryPointerMsize(freeMemoryPointer, _msize); // freeMemPtr = 0xc0 & msize = 0x120
    }
}
