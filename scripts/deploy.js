(async function main(){

  // Get our account (as deployer) to verify that a minimum wallet balance is available
  const [deployer] = await ethers.getSigners();
  console.log(`Deploying contracts with the account: ${deployer.address}`);
  console.log(`Account balance: ${(await deployer.getBalance()).toString()}`);

  // deploy logic
  async function deployContract(name) {
    let args = [ ...arguments ]; args.shift();
    if (args.length > 0) {
      console.log(`deploying ${name} with arguments:`, args);
    }
    let contract = await ethers.getContractFactory(name);
    const { address } = await contract.deploy(...args);
    console.log(`deployed[${name}]`, address);
    return address;
  }

  // deploy all
  const spacesAddr = await deployContract("Spaces");
  const carsAddr = await deployContract("Cars");
  const rewardsAddr = await deployContract("Rewards");
  const parkingAddr = await deployContract("Parking", spacesAddr, carsAddr);

  // show the verify commands
  console.log('VERIFY: wait a minute or so and then run:');
  console.log(`npx hardhat verify ${spacesAddr}`);
  console.log(`npx hardhat verify ${carsAddr}`);
  console.log(`npx hardhat verify ${rewardsAddr}`);
  console.log(`npx hardhat verify ${parkingAddr} ${spacesAddr} ${carsAddr}`);

})()
  .catch(e => {
    console.error(e);
    process.exit(1);
  })