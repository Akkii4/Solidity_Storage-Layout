// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;

contract NestedMappingToStruct {
    struct S {
        uint16 a;
        uint16 b;
        uint256 c;
    }
    uint x; // slot 0
    struct B {
        uint16 f; // slot 1
        uint16 g; // slot 1
        uint256 h; // slot 2
    }
    B b;
    mapping(uint => mapping(uint => S)) data; // slot 3

    function set(uint _key1, uint _key2, uint _c) external {
        data[_key1][_key2].c = _c;
    }

    function fetchNestedMappingData(
        uint key1,
        uint key2,
        uint256 cSlotInStruct
    ) external view returns (uint256 location, bytes32 storedVal) {
        uint256 mappingSlot;
        assembly {
            mappingSlot := data.slot
        }
        uint256 outerMappingLoc = uint256(
            keccak256(abi.encode(key1, mappingSlot))
        );
        uint256 structLocation = uint256(
            keccak256(abi.encode(key2, outerMappingLoc))
        );
        location = structLocation + cSlotInStruct;
        storedVal = getValFromSlot(location);
    }

    // Read from storage slots
    function getValFromSlot(uint256 slot) public view returns (bytes32 val) {
        assembly {
            val := sload(slot)
        }
    }
}
