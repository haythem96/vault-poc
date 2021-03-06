// SPDX-License-Identifier: MIT
pragma solidity 0.6.9;

pragma experimental ABIEncoderV2;

import { MarginAccount } from "./lib/MarginAccount.sol";
import { Actions } from "./lib/Actions.sol";

contract Controller3
{
    using MarginAccount for MarginAccount.Account;
    using MarginAccount for MarginAccount.Vault;


    mapping(address => MarginAccount.Account) internal accounts;
    mapping(address => mapping(uint256 => MarginAccount.Vault)) internal vaults;
    mapping(address => mapping(address => bool)) internal accountOperator;

    modifier isAuth(address _sender, address _userAccount) {
        require(
            isOwner(_sender, _userAccount) || isOperator(_sender, _userAccount),
            "sender is not auth"
        );

        _;
    }

    /// operate function
    /// _user the address of an account owner
    /// _vaultId the vaultId
    /// _actions array of actions
    function operate(
        address _user,
        uint256 _vaultId,
        Actions.ActionArgs[] memory _actions
    )
        external isAuth(msg.sender, _user)
    {

        // verify inputs
        // check if the msg.sender is either an account manager/operator or an account owner
        // if msg.sender is an operator of '_user' account, get '_user' account, else get sender account
        //address accountAddress = _verifyInputs(msg.sender, _user);

        /// loop through the actions
        /// if there is a open vault action, increment vault ids in the account
        /// if there is any action other than Call action, check that action argument vaultId is equal to _vaultId
        /// and check if _vaultId is less than or equal vaultIds(vault counter)
        /// so this basically will make sure all the actions belong to one vault
        _runPreprocessing(_user, _vaultId, _actions);

        // loop through action, run them and return finale vault
        MarginAccount.Vault memory finalVault = _runActions(
            _user,
            _vaultId,
            _actions
        );

        // veriy vault, basically checkMarginRequirement function
        verifyFinalState(
            finalVault
        );
    }

    function getAccountData(address _accountOwner) public view returns (address, address, uint256) {
        MarginAccount.Account memory account = accounts[_accountOwner];

        return (
            account.owner,
            account.operator,
            account.vaultIds
        );
    }

    function isOperator(address _sender, address _userAccount) public view returns (bool) {
        (, address operator , ) = getAccountData(_userAccount);
        return _sender == operator;
    }

    function isOwner(address _sender, address _userAccount) public view returns (bool) {
        (address owner, , ) = getAccountData(_userAccount);
        return _sender == owner;
    }


    function getVault(address _accountOwner, uint256 _vaultId) external view returns (MarginAccount.Vault memory) {
		return vaults[_accountOwner][_vaultId];
	}

    function isVaultOperator(address _operator, address _accountOwner) public view returns (bool) {
        return accountOperator[_operator][_accountOwner];
    }

    // use this function to check whitelised collateral
    //function _verifyInputs(address _sender, address _user) internal view returns (address) {
    //}

    // will check for Open Vault actions, execute them and make sure there is not vault id greater than vault counter;
    function _runPreprocessing(
        address _accountAddress,
        uint256 _vaultId,
        Actions.ActionArgs[] memory _actions
    ) internal {
        for(uint256 i = 0; i < _actions.length; i++) {
            Actions.ActionArgs memory action = _actions[i];
            Actions.ActionType actionType = action.actionType;
            if (actionType == Actions.ActionType.OpenVault) {
                accounts[_accountAddress].updateOnOpenVault();
                
                require(_vaultId == accounts[_accountAddress].vaultIds, "Invalid vault id");
            }
            else if (actionType != Actions.ActionType.Call) {
                require((action.vaultId == _vaultId) && (_vaultId <= accounts[_accountAddress].vaultIds), "Invalid vault id");
            }
        }
    }

    function _runActions(
        address _accountAddress,
        uint256 _vaultId,
        Actions.ActionArgs[] memory _actions
    ) internal returns (MarginAccount.Vault memory) {
        for (uint256 i = 0; i < _actions.length; i++) {
            Actions.ActionArgs memory action = _actions[i];
            Actions.ActionType actionType = action.actionType;

            if (actionType == Actions.ActionType.MintShortOption) {
                _mint(_accountAddress, Actions.parseMintShortOptionArgs(action));
            }
            /*else if (actionType == Actions.ActionType.Withdraw) {
                _withdraw(state, Actions.parseWithdrawArgs(accounts, action));
            }
            else if (actionType == Actions.ActionType.Transfer) {
                _transfer(state, Actions.parseTransferArgs(accounts, action));
            }
            else if (actionType == Actions.ActionType.Buy) {
                _buy(state, Actions.parseBuyArgs(accounts, action));
            }
            else if (actionType == Actions.ActionType.Sell) {
                _sell(state, Actions.parseSellArgs(accounts, action));
            }
            else if (actionType == Actions.ActionType.Trade) {
                _trade(state, Actions.parseTradeArgs(accounts, action));
            }
            else if (actionType == Actions.ActionType.Liquidate) {
                _liquidate(state, Actions.parseLiquidateArgs(accounts, action), cache);
            }
            else if (actionType == Actions.ActionType.Vaporize) {
                _vaporize(state, Actions.parseVaporizeArgs(accounts, action), cache);
            }
            else  {
                assert(actionType == Actions.ActionType.Call);
                _call(state, Actions.parseCallArgs(accounts, action));
            }*/
        }

        return vaults[_accountAddress][_vaultId];
    }

    function _mint(
        address _accountAddress,
        Actions.MintShortOptionArgs memory args
    )
        private
    {
        vaults[_accountAddress][args.vaultId].updateOnMintShort(args.shortOption, args.amount, args.index);

        // call Otoken mint
    }

    function verifyFinalState(
        MarginAccount.Vault memory _vault
    ) public returns (bool) {
        return _vault.shortAssets.length > 0;
    }

}
