// SPDX-License-Identifier: MIT
pragma solidity 0.6.9;


pragma experimental ABIEncoderV2;

library MarginAccount {

	struct Account {
		address owner;
		address operator;
		uint256 vaultIds;
	}

	struct Vault {
		address[] shortAssets;
		address[] longAssets;
		address[] collAssets;
		uint256[] shortAmounts;
		uint256[] longAmounts;
		uint256[] collAmounts;
  	}

	function updateOnOpenVault(
		Account storage account
	) internal {
		account.vaultIds++;
	}

	function updateOnMintShort(
		Vault storage _self,
		address _shortOtoken,
		uint256 _amount,
		uint256 _index
	) internal {
		_self.shortAssets[_index] = _shortOtoken;
		_self.shortAmounts[_index] = _self.shortAmounts[_index] + _amount;
	}

}