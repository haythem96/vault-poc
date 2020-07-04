// SPDX-License-Identifier: MIT
pragma solidity 0.6.9;


pragma experimental ABIEncoderV2;

import "./MarginAccountLibSecondImpl.sol";
import "./Controller.sol";

contract MarginAccountSecondImpl {
    /*
    
    using MarginAccountLibSecondImpl for MarginAccountLibSecondImpl.Account;
    using MarginAccountLibSecondImpl for MarginAccountLibSecondImpl.Vault;

    Controller controller;

    mapping(address => MarginAccountLibSecondImpl.Account) internal accounts;

    constructor(address _controller) public {
        controller = Controller(_controller);
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

        //MarginAccountLibSecondImpl.Account storage account = accounts[_user];

        accounts[_user].updateOnOpen(
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

    function getVault(address _user, uint256 _vaultId) external view returns (MarginAccountLib.Vault memory) {
		MarginAccountLib.Vault memory vault = _self.vaults[id];

		return vault;
	}
    */
}
