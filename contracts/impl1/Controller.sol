// SPDX-License-Identifier: MIT
pragma solidity 0.6.9;


pragma experimental ABIEncoderV2;

import "./MarginAccountLib.sol";
import "./MarginCalculator.sol";

///@notice using the commented implementation, we will encounter stack too deep error
contract Controller {
    
    using MarginAccountLib for MarginAccountLib.Account;
    using MarginAccountLib for MarginAccountLib.Vault;

    MarginCalculator calculator;

    mapping(address => MarginAccountLib.Account) internal accounts;
    mapping(address => mapping(uint256 => MarginAccountLib.Vault)) internal accountVaults;

    constructor(address _calculator) public {
        calculator = MarginCalculator(_calculator);
    }


    function getVaultCounter(address _user) external view returns (uint256) {
        MarginAccountLib.Account storage account = accounts[_user];

        return account.vaultCounter;
    }

    function getVault(address _user, uint256 _vaultId) external view returns (
        address[] memory shortAssets,
		address[] memory longAssets,
		address[] memory collAssets,
		uint256[] memory shortAmount,
		uint256[] memory longAmount,
		uint256[] memory collAmount
    ) {
        MarginAccountLib.Account storage account = accounts[_user];

        require(account.vaultCounter >= _vaultId, "error vault id");

		(shortAssets, longAssets, collAssets, shortAmount, longAmount, collAmount) = accountVaults[_user][_vaultId].getVault();
	}

    function openVault(
		address[] memory _shortAssets,
		address[] memory _longAssets,
		address[] memory _collAssets,
		uint256[] memory _shortAmounts,
		uint256[] memory _longAmounts,
		uint256[] memory _collAmounts,
        address _user
    ) external {
        require(_shortAssets.length == _shortAmounts.length, "error length");
        require(_longAssets.length == _longAmounts.length, "error length");
        require(_collAssets.length == _collAmounts.length, "error length");

        MarginAccountLib.Account storage account = accounts[_user];

        accountVaults[_user][account.vaultCounter].updateOnOpen(
            account,
            _shortAssets,
            _longAssets,
            _collAssets,
            _shortAmounts,
            _longAmounts,
            _collAmounts
        );
    }    

    /*function checkMarginRequirement(
        MarginAccountLib.RemarginVault memory modificationVault,
        address _user,
        uint256 _vaultId
    ) external view returns (bool, uint256) {
        MarginAccountLib.Vault memory vault = accountVaults[_user][_vaultId];

        MarginAccountLib.Vault vaultFinalState = updateShort(vault, modificationVault);
        
        calculator.marginRequirement(vaultFinalState);
    }*/

    /*function closeVault(
        address _user,
        uint256 _vaultId
    ) external {
        MarginAccountLib.Account memory account = accounts[_user];

        require(account.vaultCounter >= _vaultId, "error vault id");

        delete accountVaults[_user][_vaultId];
    }*/

}