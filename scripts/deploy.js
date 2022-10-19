(async function main(){

  // Get our account (as deployer) to verify that a minimum wallet balance is available
  const [deployer] = await ethers.getSigners();
  console.log(`Deploying contracts with the account: ${deployer.address}`);
  console.log(`Account balance: ${(await deployer.getBalance()).toString()}`);

  // deploy logic
  async function deployContract(name) {
    let contract = await ethers.getContractFactory(name);
    const { address } = await contract.deploy();
    console.log(`deployed[${name}]`, address);
    return address;
  }

  // deploy all
  const spacesAddr = await deployContract("Spaces");
  const carsAddr = await deployContract("Cars");
  const rewardsAddr = await deployContract("Rewards");

  // show the verify commands
  console.log('VERIFY: wait a minute or so and then run:');
  console.log(`npx hardhat verify ${spacesAddr}`);
  console.log(`npx hardhat verify ${carsAddr}`);
  console.log(`npx hardhat verify ${rewardsAddr}`);

})()
  .catch(e => {
    console.error(e);
    process.exit(1);
  })