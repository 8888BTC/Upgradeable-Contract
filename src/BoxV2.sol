// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract BoxV2 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    uint256 number;

    constructor() {
        _disableInitializers();
    }

    function initializable() public initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
    }

    function upgradeNumber(uint256 _number) public {
        number = _number;
    }

    function version() public pure returns (uint256) {
        return 2;
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
}
