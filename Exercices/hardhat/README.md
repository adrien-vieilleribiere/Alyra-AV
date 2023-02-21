# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

```shell
npm install @truffle/hdwallet-provider 

npx hardhat compile
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js
npx hardhat run scripts/deploy.js --network localhost 
npx hardhat console --network localhost
```

in console:
```shell
const Lock = await ethers.getContractFactory('Lock');
const lock = await Lock.attach('0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0'); 
// use the adress logged in deployment
await lock.owner()
awail lock.unlockTime()
```