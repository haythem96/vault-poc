// SPDX-License-Identifier: MIT
pragma solidity 0.6.9;


pragma experimental ABIEncoderV2;

library MarginAccountLib {

	struct Account {
		uint256 vaultCounter;
	}

	struct Vault {
		mapping(address => uint256) shortAmount;
		mapping(address => uint256) longAmount;
		mapping(address => uint256) collateralAmount;
		address[] shortAssets;
		address[] longAssets;
		address[] collAssets;
  	}
	
	function updateOnOpen(
		Vault storage _self,
		address[] calldata _shortAssets,
		address[] calldata _longAssets,
		address[] calldata _collAssets,
		uint256[] calldata _shortAmounts,
		uint256[] calldata _longAmounts,
		uint256[] calldata _collAmounts
	) internal {
		for(uint8 i = 0; i<_shortAssets.length; i++) {
			_self.shortAmount[_shortAssets[i]] = _shortAmounts[i];
		}

		for(uint8 i = 0; i<_longAssets.length; i++) {
			_self.longAmount[_longAssets[i]] = _longAmounts[i];
		}

		for(uint8 i = 0; i<_collAssets.length; i++) {
			_self.collateralAmount[_collAssets[i]] = _collAmounts[i];
		}

		_self.shortAssets = _shortAssets;
		_self.longAssets = _longAssets;
		_self.collAssets = _collAssets;
	}

	function updateOnClose(
		Vault storage _self
	) internal {
		for(uint8 i = 0; i<_self.shortAssets.length; i++) {
			_self.shortAmount[_self.shortAssets[i]] = 0;
		}

		for(uint8 i = 0; i<_self.longAssets.length; i++) {
			_self.shortAmount[_self.longAssets[i]] = 0;
		}

		for(uint8 i = 0; i<_self.collAssets.length; i++) {
			_self.shortAmount[_self.collAssets[i]] = 0;
		}

		address[] memory emptyAddresses;
		_self.shortAssets = emptyAddresses;
		_self.longAssets = emptyAddresses;
		_self.collAssets = emptyAddresses;
  	}

	function setReserveId(
		Account storage _self
	) internal {
		_self.vaultCounter++;
	}


}