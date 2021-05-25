const SmCGovToken = artifacts.require("SmCGovToken");
const MissionControl = artifacts.require("MissionControl");
const StasisControl = artifacts.require("StasisControl");

module.exports = function (deployer) {
  deployer.deploy(SmCGovToken);
  deployer.deploy(MissionControl);
  deployer.deploy(StasisControl);
};
