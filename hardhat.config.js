require("@nomiclabs/hardhat-waffle");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("Deploy", "Deploys the Safemoon Cash Governance model"
.addParam("token", "Initial token distribution address")
.addParam("timelock", "Initial Timelock Admin address")
.addParam("guardian", "The Governance Guardian").setAction(async taskArgs => {

	const { deploy } = require("./scripts/Deploy");
	
		await deploy({
			tokenRecipient: taskArgs.token,
			timelockAdmin: taskArgs.timelock,
			guardian: taskArgs.guardian
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
	networks: {
		Kovan: {
			
	},
 	solidity: "0.6.12",
};
