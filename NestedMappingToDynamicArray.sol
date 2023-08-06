// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract NestedMappingToDynamicArray {
    // State variables
    uint256 public totalSupply = 1_000_000e18; // slot 0
    mapping(address => uint256[]) userNFTHoldings; // slot 1

    function set(address _user, uint256[] calldata _amount) external {
        userNFTHoldings[_user] = _amount;
    }

    function fetchNestedMappingData(
        address key1,
        uint256 arrayElementIndex
    ) external view returns (uint256 arrayElementLocation, bytes32 storedVal) {
        uint256 mappingSlotInStorage;
        assembly {
            mappingSlotInStorage := userNFTHoldings.slot
        }
        uint256 dynamicArrayStorageSlot = uint256(
            keccak256(abi.encode(key1, mappingSlotInStorage))
        );
        arrayElementLocation = uint256(
            keccak256(abi.encode(dynamicArrayStorageSlot))
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
