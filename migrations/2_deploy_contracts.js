const ZineCollection = artifacts.require("ZineCollection");

module.exports = function (deployer) {
    deployer.deploy(ZineCollection, "Total", "Zine", "");
};