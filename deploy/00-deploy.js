const { network } = require("hardhat");
const { verify } = require("../utils/verify");
require("dotenv").config();

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = await getChainId();

  const nft = await deploy("nftStakeTest", {
    // Learn more about args here: https://www.npmjs.com/package/hardhat-deploy#deploymentsdeploy
    from: deployer,
    // args: [ "Hello", ethers.utils.parseEther("1.5") ],
    log: true,
    waitConfirmations: network.config.blockConfirmations || 1,
  });

  // Getting a previously deployed contract
  console.log(`NFT deployed at ${nft.address}`);

  if (network.name == "goerli" && process.env.ETHERSCAN_API_KEY) {
    await verify(nft.address);
    console.log(`NFT verified~~~~~~`);
  }

  const coin = await deploy("Shuaicoin", {
    from: deployer,
    args: [true, nft.address],
    log: true,
    waitConfirmations: network.config.blockConfirmations || 1,
  });

  console.log(`Coin deployed at ${coin.address}`);

  if (network.name == "goerli" && process.env.ETHERSCAN_API_KEY) {
    await verify(coin.address, [true, nft.address]);
    console.log(`Coin verified~~~~~~`);
  }
};
