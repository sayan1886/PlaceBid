var UserRecord = artifacts.require('./contracts/UserRecord.sol');
var AssetRecord = artifacts.require('./contracts/AssetRecord.sol');
var AuctionRecord = artifacts.require('./contracts/AuctionRecord.sol');

module.exports = function(deployer) {
    return deployer.deploy(UserRecord)
        .then(() => deployer.deploy(AssetRecord))
        .then(() => deployer.deploy(AuctionRecord));
};