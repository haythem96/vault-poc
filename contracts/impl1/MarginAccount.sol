// SPDX-License-Identifier: MIT
pragma solidity 0.6.9;


pragma experimental ABIEncoderV2;

import "./MarginAccountLib.sol";

///@notice using the commented implementation, we will encounter stack too deep error
/*contract MarginAccount {
    
    using MarginAccountLib for MarginAccountLib.Account;
    using MarginAccountLib for MarginAccountLib.Vault;

    mapping(address => MarginAccountLib.Account) internal accounts;
    mapping(address => mapping(uint256 => MarginAccountLib.Vault)) internal accountVaults;

    constructor() public {
    }

    function openVault(
        address _user,
		address[] memory _shortAssets,
		address[] memory _longAssets,
		address[] memory _collAssets,
		uint256[] memory _shortAmounts,
		uint256[] memory _longAmounts,
		uint256[] memory _collAmounts
    ) public {
        require(msg.sender == address(controller), "controller auth failed");
        require(_shortAssets.length == _shortAmounts.length, "error length");
        require(_longAssets.length == _longAmounts.length, "error length");
        require(_collAssets.length == _collAmounts.length, "error length");

        MarginAccountLib.Account storage account = accounts[_user];

        accounts[_user].setReserveId();

        accountVaults[_user][account.vaultCounter].updateOnOpen(
            _shortAssets,
            _longAssets,
            _collAssets,
            _shortAmounts,
            _longAmounts,
            _collAmounts
        );
    }

    function closeVault(
        address _user,
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

        MarginAccountLib.Account storage account = accounts[_user];

        require(account.vaultCounter >= _vaultId, "error vault id");

        accountVaults[_user][_vaultId].updateOnClose();
    }
}*/

contract Controller {
    
    using MarginAccountLib for MarginAccountLib.Account;
    using MarginAccountLib for MarginAccountLib.Vault;

    mapping(address => MarginAccountLib.Account) internal accounts;
    mapping(address => mapping(uint256 => MarginAccountLib.Vault)) internal accountVaults;


    function openVault(
		address[] memory _shortAssets,
		address[] memory _longAssets,
		address[] memory _collAssets,
		uint256[] memory _shortAmounts,
		uint256[] memory _longAmounts,
		uint256[] memory _collAmounts
    ) public {
        require(_shortAssets.length == _shortAmounts.length, "error length");
        require(_longAssets.length == _longAmounts.length, "error length");
        require(_collAssets.length == _collAmounts.length, "error length");

        MarginAccountLib.Account storage account = accounts[msg.sender];

        accounts[msg.sender].setReserveId();

        accountVaults[msg.sender][account.vaultCounter].updateOnOpen(
            _shortAssets,
            _longAssets,
            _collAssets,
            _shortAmounts,
            _longAmounts,
            _collAmounts
        );
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

        MarginAccountLib.Account storage account = accounts[msg.sender];

        require(account.vaultCounter >= _vaultId, "error vault id");

        accountVaults[msg.sender][_vaultId].updateOnClose();
    }

    /// @notice the below function can not return a Vault structure
    /// only libraries are allowed to use mapping type in public or external functions.
    /*function getVault(address _user, uint256 _vaultId) external view returns (MarginAccountLib.Vault memory) {
        MarginAccountLib.Account storage account = accounts[_user];

        require(account.vaultCounter >= _vaultId, "error vault id");

		MarginAccountLib.Vault memory vault = accountVaults[_user][_vaultId];

		return vault;
	}*/

}