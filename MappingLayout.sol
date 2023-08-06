// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract MappingLayout {
    // State variables
    uint256 public totalSupply = 1_000_000e18; // slot 0
    mapping(address => uint256) balanceOf; // slot 1
    mapping(uint256 => uint256) somethingElse; // slot 2

    function setBalance(address _user, uint256 _amount) external {
        balanceOf[_user] = _amount;
        somethingElse[_amount] = _amount * 5;
    }

    function fetchMappingLocation(
        uint256 mappingKey,
        uint256 mappingStorageSlot
    ) external pure returns (uint256) {
        return uint256(keccak256(abi.encode(mappingKey, mappingStorageSlot)));
    }

    // Read from storage slots
    function getValFromSlot(uint256 slot) external view returns (bytes32 val) {
        assembly {
            val := sload(slot)
        }
    }
}
