// SPDX-License-Identifier: MIT
pragma solidity 0.6.9;


pragma experimental ABIEncoderV2;

library MarginAccountLib {

	struct Account {
		uint256 vaultCounter;
	}

	struct Vault {
		address[] shortAssets;
		address[] longAssets;
		address[] collAssets;
		mapping(address => uint256) shortAmount;
		mapping(address => uint256) longAmount;
		mapping(address => uint256) collAmount;
  	}

	/*struct RemarginVault {
        address[] shortAssets;
		address[] longAssets;
		address[] collAssets;
		uint256[] shortAmounts;
		uint256[] longAmounts;
		uint256[] collAmounts;
        uint8[] shortOp;
		uint8[] longOp;
		uint8[] collOp;
    }*/

	function setReserveId(
		Account storage _self
	) internal {
		_self.vaultCounter++;
	}
	
	function updateOnOpen(
		Vault storage _self,
		Account storage _account,
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
			_self.collAmount[_collAssets[i]] = _collAmounts[i];
		}

		_self.shortAssets = _shortAssets;
		_self.longAssets = _longAssets;
		_self.collAssets = _collAssets;

		setReserveId(_account);
	}

	function getVault(
		Vault storage _vault
	) internal view returns (
        address[] memory,
		address[] memory,
		address[] memory,
		uint256[] memory,
		uint256[] memory,
		uint256[] memory
    ) {
		uint256[] memory shortAmount;
		uint256[] memory longAmount;
		uint256[] memory collAmount;

		for(uint8 i = 0; i<_vault.shortAssets.length; i++) {
			shortAmount[i] = _vault.shortAmount[_vault.shortAssets[i]];
		}

		for(uint8 i = 0; i<_vault.longAssets.length; i++) {
			longAmount[i] = _vault.longAmount[_vault.longAssets[i]];
		}

		for(uint8 i = 0; i<_vault.collAssets.length; i++) {
			collAmount[i] = _vault.collAmount[_vault.collAssets[i]];
		}

		return (_vault.shortAssets, _vault.longAssets, _vault.collAssets, shortAmount, longAmount, collAmount);
	}

	/*function getVaultFinalState(
		Vault memory _updateVault,
		Vault memory _vault
	) internal view returns (Vault memory) {
		for(uint8 i = 0; i<_vault.shortAssets.length; i++) {
			_updateVault.shortAmount[_vault.shortAssets[i]] = _shortAmounts[i];
		}

		for(uint8 i = 0; i<_vault.longAssets.length; i++) {
			_self.longAmount[_longAssets[i]] = _longAmounts[i];
		}

		for(uint8 i = 0; i<_vault.collAssets.length; i++) {
			_self.collAmount[_collAssets[i]] = _collAmounts[i];
		}

		return _vault;
	}*/
}