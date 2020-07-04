// impl1 deployment
const MarginAccountLib = artifacts.require("MarginAccountLib.sol");
const Controller = artifacts.require("Controller.sol");
const MarginCalculator = artifacts.require("MarginCalculator.sol");
// impl2 deployment
const MarginAccountLib2 = artifacts.require("MarginAccountLib2.sol");
const Controller2 = artifacts.require("Controller2.sol");
const MarginCalculator2 = artifacts.require("MarginCalculator2.sol");

module.exports = function (deployer, network) {
    if(network == "development") {
        deployer.then(async () => {
            //deploy impl1
            await deployer.deploy(MarginAccountLib);

            let calculator = await deployer.deploy(MarginCalculator);

            await deployer.link(MarginAccountLib, Controller);
            await deployer.deploy(Controller, calculator.address);

            //deploy impl2
            await deployer.deploy(MarginAccountLib2);

            let calculator = await deployer.deploy(MarginCalculator2);
            
            await deployer.link(MarginAccountLib2, Controller2);
            await deployer.deploy(Controller2, calculator.address);
        });   
    }
}