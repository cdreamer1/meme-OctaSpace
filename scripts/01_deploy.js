const { ethers } = require("hardhat");

async function main() {
  const OctaInu = await ethers.getContractFactory(
    "OCTAINU"
  );
  const OctaInuContract = await OctaInu.deploy();

  console.log("OctaInu Contract deployed to: ", OctaInuContract.target);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
