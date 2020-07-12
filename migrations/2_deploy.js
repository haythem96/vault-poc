const Actions = artifacts.require("Actions.sol");
const MarginAccount = artifacts.require("MarginAccount.sol");
const Controller3 = artifacts.require("Controller3.sol");

module.exports = function (deployer, network) {
    if(network == "development") {
        deployer.then(async () => {
            await deployer.deploy(MarginAccount);
            
            await deployer.link(MarginAccount, Controller3);
            await deployer.deploy(Controller3);
        });   
    }
}