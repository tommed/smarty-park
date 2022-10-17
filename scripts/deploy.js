(async function main(){

  // Get our account (as deployer) to verify that a minimum wallet balance is available
  const [deployer] = await ethers.getSigners();
  console.log(`Deploying contracts with the account: ${deployer.address}`);
  console.log(`Account balance: ${(await deployer.getBalance()).toString()}`);

  // deploy
  const contract = await ethers.getContractFactory("Spaces");
  const ret = await contract.deploy();
  console.log('deployed contract to', ret.address);

})()
  .catch(e => {
    console.error(e);
    process.exit(1);
  })