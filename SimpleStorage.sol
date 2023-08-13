// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract SimpleStorage {
    // State variables
    uint256 public x; // slot 0
    address public user; // slot 1
    uint64 public y; // slot 1
    uint128 public z; // slot 2

    // Set state variables
    function set(uint256 _x, address _user, uint64 _y, uint128 _z) external {
        x = _x;
        user = _user;
        y = _y;
        z = _z;
    }

    // Read from storage slots
    function getVarFromSlot(uint256 slot) external view returns (bytes32 val) {
        assembly {
            val := sload(slot)
        }
    }
}
