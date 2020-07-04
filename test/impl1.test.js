const TokenMock = artifacts.require("TokenMock");

const Controller = artifacts.require("Controller.sol");

contract("Impl 1", (accounts) => {
    let shortToken, longToken, collToken;
    let controller, calculator;

    before(async () => {
        shortToken = await TokenMock.new("short");
        longToken = await TokenMock.new("long");
        collToken = await TokenMock.new("collateral");

        controller = await Controller.deployed();
    });

    describe('Tests', () => {
        it('should get vault counter', async () => {
            let length = await controller.getVaultCounter(
                accounts[0]
            );

            console.log(length.toString());
        });

        it('should get vault', async () => {
            let vault = await controller.getVault(
                accounts[0],
                0
            );

            console.log(vault);
        });

        /*it('should open vault', async () => {
            let _shortAssets = [shortToken.address];
            let _longAssets = [longToken.address];
            let _collAssets = [collToken.address];
            let _shortAmounts = [100];
            let _longAmounts = [90];
            let _collAmounts = [10];

            await controller.openVault(
                _shortAssets,
                _longAssets,
                _collAssets,
                _shortAmounts,
                _longAmounts,
                _collAmounts,
                accounts[0]
            );

            let length = await controller.getVaultCounter(
                accounts[0]
            );

            console.log(length.toString());

            let vault = await controller.getVault(
                accounts[0],
                0
            );

            console.log(vault);
        });*/

        it('should check requirement withoud modifying vault state', async () => {
        });
    });
});
