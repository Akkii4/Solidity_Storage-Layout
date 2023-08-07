// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// A dangling reference is a reference that points to something that no longer exists or has been moved without updating the reference.
// Avoid dangling reference in code
contract DanglingStorageReference {
    uint[][] s;

    function store() public {
        s.push();
        s[0] = [55, 23, 92];
    }

    function performDangling() public {
        // Stores a pointer to the last array element of s.
        uint[] storage ptr = s[s.length - 1];
        // Removes the last array element of s.
        s.pop();
        // Not revert, despite ptr no longer refers to valid element of s
        // Writes to the array element that is no longer within the array.
        ptr.push(0x42);
        // Adding a new element to ``s`` now will not add an empty array, but
        // will result in an array of length 1 with ``0x42`` as element.
        s.push();
        assert(s[s.length - 1][0] == 0x42);
    }

    function fetchNestedDynamicArrayData(
        uint256 arrayElementIndex
    ) external view returns (uint256 arrayElementLocation, bytes32 storedVal) {
        uint256 nestedDynamicArraySlotInStorage;
        assembly {
            nestedDynamicArraySlotInStorage := s.slot
        }
        arrayElementLocation = uint256(
            keccak256(abi.encode(nestedDynamicArraySlotInStorage))
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
