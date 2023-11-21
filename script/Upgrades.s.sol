// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {BoxV2} from "../src/BoxV2.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract Upgrades is Script {
    function run() external returns (address) {
        address contractAddress = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);
        vm.startBroadcast();
        BoxV2 boxV2 = new BoxV2();
        vm.stopBroadcast();

        address proxy = getUpgradeToBoxV2(contractAddress, address(boxV2));
        return address(proxy);
    }

    function getUpgradeToBoxV2(address contractAddress, address boxV2) public returns (address) {
        vm.startBroadcast();
        BoxV1 proxy = BoxV1(payable(address(contractAddress)));
        proxy.upgradeToAndCall(address(boxV2), "");
        vm.stopBroadcast();

        return address(proxy);
    }
}
