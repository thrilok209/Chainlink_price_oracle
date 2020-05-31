const GetPrice = artifacts.require("GetPrice");

module.exports = function(deployer) {
  deployer.deploy(GetPrice);
};
