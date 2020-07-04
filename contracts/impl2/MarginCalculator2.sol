// SPDX-License-Identifier: MIT
pragma solidity 0.6.9;


pragma experimental ABIEncoderV2;

import "./MarginAccountLib2.sol";

contract MarginCalculator2 {

    function marginRequirement(
        MarginAccountLib2.Vault memory _vault
    ) external pure returns (uint256) {
        require(_vault.shortAssets.length == 1, "error short assets length");

        return 0;
    }

}