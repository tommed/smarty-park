# Deploy

1. Create a **.env** file in the root directory and add the [neccessary values](./hardhat.config.js)
1. `yarn compile` - make sure it compiles clean
1. `yarn deploy` - copy the contract address and add it to the **.env** file
1. `npx hardhat verify --network mumbai CONTRACT_ADDRESS_HERE` to verify this function
1. Go to: https://mumbai.polygonscan.com/address/CONTRACT_ADDRESS_HERE