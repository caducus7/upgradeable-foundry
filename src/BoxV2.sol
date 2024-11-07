//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract BoxV1 {
    uint256 internal value;

    function setValue(uint256 _value) external {
        value = _value;
    }

    function getValue() external view returns (uint256) {
        return value;
    }

    function version() external pure returns (uint256) {
        return 1;
    }
}
