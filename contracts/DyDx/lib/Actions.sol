// SPDX-License-Identifier: MIT
pragma solidity 0.6.9;

pragma experimental ABIEncoderV2;

import { MarginAccount } from "./MarginAccount.sol";

library Actions {

    enum ActionType {
        OpenVault,
        MintShortOption,
        BurnShortOption,
        DepositLongOption,
        WithdrawLongOption,
        DepositCollateral,
        WithdrawCollateral,
        Call
    }

    struct ActionArgs {
        ActionType actionType;
        address sender;
        address asset;
        uint256 vaultId;
        uint256 amount;
        uint256 index;
    }

    struct MintShortOptionArgs {
        address shortOption;
        uint256 vaultId;
        uint256 amount; // or struct, similar comment to the one above
        uint256 index;
    }

    struct BurnShortOptionArgs {
        MarginAccount.Account account;
        address shortOption;
        uint256 vaultId;
        uint256 amount; // or struct, similar comment to the one above
        uint256 index;
    }

    struct DepositLongOptionArgs {
        MarginAccount.Account account;
        uint256 vaultId;
        address longOption;
        address from;
        uint256 amount;
        uint256 index;
    }

    struct WithdrawLongOptionArgs {
        MarginAccount.Account account;
        uint256 vaultId;
        address longOption;
        address to;
        uint256 amount;
        uint256 index;
    }

    struct DepositCollateralArgs {
        MarginAccount.Account account;
        uint256 vaultId;
        address collateral;
        address from;
        uint256 amount;
        uint256 index;
    }

    struct WithdrawCollateralArgs {
        MarginAccount.Account account;
        uint256 vaultId;
        address collateral;
        address to;
        uint256 amount;
        uint256 index;
    }

    // ============ Parsing Functions ============

    function parseMintShortOptionArgs(
        ActionArgs memory args
    )
        internal
        pure
        returns (MintShortOptionArgs memory)
    {
        assert(args.actionType == ActionType.MintShortOption);
        return MintShortOptionArgs({
            shortOption: args.asset,
            vaultId: args.vaultId,
            amount: args.amount,
            index: args.index
        });
    }

}