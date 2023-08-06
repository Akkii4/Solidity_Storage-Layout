// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// Mappings leave their slot p(mapping slot in the contract's storage) empty (to avoid clashes),
// the values corresponding to key k are stored at slot location : keccak(h(k), p)
contract NestedMappingLayout {
    // State variables
    uint256 public totalSupply = 1_000_000e18; // slot 0
    mapping(address => mapping(address => uint256)) userNFTBalance; // slot 1

    function setBalance(
        address _user,
        address _nftContract,
        uint256 _amount
    ) external {
        userNFTBalance[_user][_nftContract] = _amount;
    }

    function fetchNestedMappingData(
        address key1,
        address key2
    ) external view returns (uint256 location, bytes32 storedVal) {
        uint256 mappingSlotInStorage;
        assembly {
            mappingSlotInStorage := userNFTBalance.slot
        }
        uint256 outerMappingLoc = uint256(
            keccak256(abi.encode(key1, mappingSlotInStorage))
        );
        location = uint256(keccak256(abi.encode(key2, outerMappingLoc)));
        storedVal = getValFromSlot(location);
    }

    // Read from storage slots
    function getValFromSlot(uint256 slot) public view returns (bytes32 val) {
        assembly {
            val := sload(slot)
        }
    }
}
