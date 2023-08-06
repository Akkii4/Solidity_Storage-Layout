// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract ArrayLayout {
    // State variables
    uint256[5] fixedArray = [13, 23, 33, 43, 53]; // slot 0-4
    uint256[] bigDynamicArray; // slot 5 (stores length of this dynamic array at this slot)
    uint8[] smallDynamicArray; // slot 6 (stores length of this dynamic array at this slot)

    function set(uint256[] calldata _dynamicArray) external {
        for (uint i = 0; i < _dynamicArray.length; i++) {
            bigDynamicArray.push(_dynamicArray[i]);
        }
        smallDynamicArray = [
            1,
            2,
            3,
            4,
            5,
            6,
            7,
            8,
            9,
            10,
            11,
            12,
            13,
            14,
            15,
            16,
            17,
            18,
            19,
            20,
            21,
            22,
            23,
            24,
            25,
            26,
            27,
            28,
            29,
            30,
            31,
            32,
            33,
            34,
            35,
            36,
            37,
            38,
            39,
            40
        ];
    }

    function fetchFixedArrayData(
        uint256 arrayElementIndex
    ) external view returns (uint256 storedVal) {
        uint256 fixedArraySlotInStorage;
        assembly {
            fixedArraySlotInStorage := fixedArray.slot
        }
        storedVal = uint256(
            getValFromSlot(fixedArraySlotInStorage + arrayElementIndex)
        );
    }

    /**
    * Dynamically-sized array's length is stored as the first slot at location p, 
        it's values start being stores at keccak256(p) one element after the other, 
        potentially sharing storage slots if the elements are not longer than 16 bytes.
    */
    function fetchBigDynamicArrayData(
        uint256 arrayElementIndex
    ) external view returns (uint256 arrayElementLocation, bytes32 storedVal) {
        uint256 dynamicArraySlotInStorage;
        assembly {
            dynamicArraySlotInStorage := bigDynamicArray.slot
        }
        arrayElementLocation = uint256(
            keccak256(abi.encode(dynamicArraySlotInStorage))
        );
        storedVal = getValFromSlot(arrayElementLocation + arrayElementIndex);
    }

    function fetchSmallDynamicArrayData(
        uint256 arrayElementIndex
    ) external view returns (uint256 arrayElementLocation, bytes32 storedVal) {
        uint256 dynamicArraySlotInStorage;
        assembly {
            dynamicArraySlotInStorage := smallDynamicArray.slot
        }
        arrayElementLocation = uint256(
            keccak256(abi.encode(dynamicArraySlotInStorage))
        );
        storedVal = getValFromSlot(arrayElementLocation + arrayElementIndex);
    }

    // Read from storage slots
    function getValFromSlot(uint256 slot) public view returns (bytes32 val) {
        assembly {
            val := sload(slot)
        }
    }
}
