//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";

contract DeployAndUpgradeTest is Test {
    DeployBox deployBox;
    UpgradeBox upgradeBox;
    address public OWNER = makeAddr("owner");
    address public proxy;

    function setUp() public {
        deployBox = new DeployBox();
        upgradeBox = new UpgradeBox();

        proxy = deployBox.run(); //points to boxV1
    }

    function testShouldRevertIfNoUpgrade() public {
        vm.expectRevert();
        BoxV2(proxy).setNumber(77);
    }

    function testUpgrades() public {
        BoxV2 boxV2 = new BoxV2();
        vm.prank(BoxV1(proxy).owner());
        BoxV1(proxy).transferOwnership(msg.sender);
        address newProxyAddress = upgradeBox.upgradeBox(proxy, address(boxV2));

        uint256 expectedVersion = 2;
        assertEq(expectedVersion, BoxV2(newProxyAddress).version());

        uint256 expectedNumber = 77;
        BoxV2(proxy).setNumber(expectedNumber);

        assertEq(expectedNumber, BoxV2(newProxyAddress).getNumber());
    }
}
