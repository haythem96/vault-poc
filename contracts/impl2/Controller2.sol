// SPDX-License-Identifier: MIT
pragma solidity 0.6.9;


pragma experimental ABIEncoderV2;

import "./MarginAccountLib2.sol";
import "./MarginCalculator2.sol";

contract Controller2 {
    
    using MarginAccountLib2 for MarginAccountLib2.Account;
    using MarginAccountLib2 for MarginAccountLib2.Vault;

    MarginCalculator2 calculator;

    mapping(address => MarginAccountLib2.Account) internal accounts;
    mapping(address => mapping(uint256 => MarginAccountLib2.Vault)) internal accountVaults;

    constructor(address _calculator) public {
        calculator = MarginCalculator2(_calculator);
    }

    function getVaultCounter(address _user) external view returns (uint256) {
        MarginAccountLib2.Account storage account = accounts[_user];

        return account.vaultCounter;
    }

    function openVault(
		address[] memory _shortAssets,
		address[] memory _longAssets,
		address[] memory _collAssets,
		uint256[] memory _shortAmounts,
		uint256[] memory _longAmounts,
		uint256[] memory _collAmounts,
        address _user
    ) public {
        require(_shortAssets.length == _shortAmounts.length, "error length");
        require(_longAssets.length == _longAmounts.length, "error length");
        require(_collAssets.length == _collAmounts.length, "error length");

        MarginAccountLib2.Account storage account = accounts[_user];

        accountVaults[_user][account.vaultCounter].updateOnOpen(
            account,
            _shortAssets,
            _longAssets,
            _collAssets,
            _shortAmounts,
            _longAmounts,
            _collAmounts
        );

        uint256 marginRequirement = calculator.marginRequirement(accountVaults[_user][account.vaultCounter-1]);

        require(marginRequirement == 0, "margin fail");
    }

    function closeVault(
        uint256 _vaultId,
        address[] memory _shortAssets,
        address[] memory _longAssets,
        address[] memory _collAssets,
        uint256[] memory _shortAmounts,
        uint256[] memory _longAmounts,
        uint256[] memory _collAmounts
    ) external {
        require(_shortAssets.length == _shortAmounts.length, "error length");
        require(_longAssets.length == _longAmounts.length, "error length");
        require(_collAssets.length == _collAmounts.length, "error length");

        MarginAccountLib2.Account memory account = accounts[msg.sender];

        require(account.vaultCounter >= _vaultId, "error vault id");

        delete accountVaults[msg.sender][_vaultId];
    }

    function checkMarginRequirement(
        address _user,
        uint256 _vaultId,
        address[] memory _shortAssets,
        address[] memory _longAssets,
        address[] memory _collAssets,
        uint256[] memory _shortAmounts,
        uint256[] memory _longAmounts,
        uint256[] memory _collAmounts
    ) external view returns (bool, uint256) {
        require(_shortAssets.length == _shortAmounts.length, "error length");
        require(_longAssets.length == _longAmounts.length, "error length");
        require(_collAssets.length == _collAmounts.length, "error length");

        MarginAccountLib2.Vault memory vault = getVault(_user, _vaultId);
        
        vault.shortAmounts[0] = vault.shortAmounts[0] + _shortAmounts[0];
        vault.longAmounts[0] = vault.longAmounts[0] + _longAmounts[0];

        vault.collAmounts[0] = vault.collAmounts[0] + _collAmounts[0];

        vault.shortAssets[0] = _shortAssets[0];
        vault.longAssets[0] = _longAssets[0];

        vault.collAssets[0] = _collAssets[0];

        calculator.marginRequirement(vault);
    }

    function getVault(address _user, uint256 _vaultId) public view returns (MarginAccountLib2.Vault memory) {
        MarginAccountLib2.Account storage account = accounts[_user];

        require(account.vaultCounter >= _vaultId, "error vault id");

		MarginAccountLib2.Vault memory vault = accountVaults[_user][_vaultId];

		return vault;
	}

    function bitShift(uint256 ui) external pure returns(uint256) {
        return  ui<<31;
    }

}