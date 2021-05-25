const hre = require("hardhat");
const ethers = hre.ethers;

async function main({tokenRecipient, timelockAdmin, guardian}) {

	await hre.run('compile');

	const [tokenRecipient, timelockAdmin, guardian] = await ethers.getSigners();

	const Token = await hre.ethers.getContractFactory("SmCGov");
	const token = await Token.deploy(tokenRecipient.address);
	await token.deployed();
	await token.deployTransaction.wait();

	const delay = 432000;
	const Timelock = await ethers.getContractFactory("StasisControl");
	const timelock = await Timelock.deploy(timelockAdmin.address, delay);
	await timelock.deployed();
	await timelock.deployTransaction.wait();

	const Gov = await ethers.getContractFactory("MissionControl");
	const gov = await Gov.deploy(timelock.address, token.address, guardian.address);
	await gov.deployed();
	await gov.deployTransaction.wait();

	console.log('Stasis deployed to: ${timelock.address}')
	console.log('Token deployed to: ${token.address}');
	console.log('MissionControl deployed to: ${missionControl.address}');


	const initialBalance = await token.balanceOf(tokenRecipient.address);
	console.log('10000000 tokens transfered to ${tokenRecipient.address}');

}

module.exports = {
		deploy: main
	}