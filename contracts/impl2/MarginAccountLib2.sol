// SPDX-License-Identifier: MIT
pragma solidity 0.6.9;


pragma experimental ABIEncoderV2;

library MarginAccountLib2 {

	struct Account {
		uint256 vaultCounter;
	}

	struct Vault {
		address[] shortAssets;
		address[] longAssets;
		address[] collAssets;
		uint256[] shortAmounts;
		uint256[] longAmounts;
		uint256[] collAmounts;
  	}

	function setReserveId(
		Account storage _self
	) internal {
		_self.vaultCounter++;
	}
	
	function updateOnOpen(
		Vault storage _self,
		address[] memory _shortAssets,
		address[] memory _longAssets,
		address[] memory _collAssets,
		uint256[] memory _shortAmounts,
		uint256[] memory _longAmounts,
		uint256[] memory _collAmounts
	) internal {
		for(uint8 i = 0; i<_shortAssets.length; i++) {
			_self.shortAssets[i] = _shortAssets[i];
			_self.shortAmounts[i] = _shortAmounts[i];
		}

		for(uint8 i = 0; i<_longAssets.length; i++) {
			_self.longAssets[i] = _longAssets[i];
			_self.longAmounts[i] = _longAmounts[i];
		}

		for(uint8 i = 0; i<_collAssets.length; i++) {
			_self.collAssets[i] = _collAssets[i];
			_self.collAmounts[i] = _collAmounts[i];
		}
	}
}