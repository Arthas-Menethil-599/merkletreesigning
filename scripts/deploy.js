const { ethers, run, network } = require("hardhat");


async function main() {
  const constructorArgument = "0x9d056892c96040c8ffac7a8510e528347fb4d6c7b809d6e99a179da7c2eca2fe";
  const signingFactory = await ethers.getContractFactory("MerkleTreeSigning");
  const contract = await signingFactory.deploy(constructorArgument);
  await contract.deployed();
  console.log(`Contract address: ${contract.address}`);

  console.log(network.config);
  if(network.config.chainId === 97) {
    contract.deployTransaction.wait(15);
    verify(contract.address, [constructorArgument]);
  }
}

async function verify(contractAddress, arguments) {
  try{
    await run("verify:verify", {
      address: contractAddress,
      constructorArguments: arguments,
    });
  }
  catch(e) {
    if(e.message.toLowerCase.include("already verified")) {
      console.log("The contract already verified.");
    }
    else {
      console.log(e);
    }
  }
}

main().then(()=> process.exit(0)).catch((error) =>  {
  console.error(error);
  process.exit(1);
});