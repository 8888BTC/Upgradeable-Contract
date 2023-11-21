// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {BoxV1} from "../src/BoxV1.sol";

import {BoxV2} from "../src/BoxV2.sol";

import {DeployProxyAndUpgrades} from "../script/DeployProxyAndUpgrades.s.sol";

import {Upgrades} from "../script/Upgrades.s.sol";

import {Test, console} from "forge-std/Test.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployAndUpgradesTest is Test {
    DeployProxyAndUpgrades public proxyOfBoxV1;

    Upgrades public proxyOfBoxV2;

    address USER = makeAddr("USER");

    function setUp() external {
        proxyOfBoxV1 = new DeployProxyAndUpgrades();
        proxyOfBoxV2 = new Upgrades();
    }

    function testBoxWorks() public {
        address proxy = proxyOfBoxV1.deployProxy();
        uint256 expectValued = 1;
        assert(expectValued == BoxV1(proxy).version());

        vm.prank(USER);
        BoxV1(proxy).upgradeNumber(5);
        uint256 expectNumber = 5;
        assert(expectNumber == BoxV1(proxy).getNumber());
    }

    function testUpgradesBoxV2() public {
        address proxyAddress = proxyOfBoxV1.deployProxy();
        BoxV2 boxV2 = new BoxV2();

        vm.prank(BoxV1(proxyAddress).owner());
        BoxV1(proxyAddress).transferOwnership(msg.sender);

        address proxy = proxyOfBoxV2.getUpgradeToBoxV2(proxyAddress, address(boxV2));

        uint256 expectVersion = 2;

        assert(expectVersion == BoxV2(proxy).version());
    }
}
