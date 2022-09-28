const main = async () => {
    const nftContractFactory = await hre.ethers.getContractFactory('TenPrintNFT'); // compile contract and generate necessarily files (under artifacts folder)
    const nftContract = await nftContractFactory.deploy(); // create local Ethereum network and deploy contract
    await nftContract.deployed(); // wait for contract to be officially mined and deployed
    console.log("Contract deployed to:", nftContract.address); // give address of deployed contract

    let txn1 = await nftContract.mint10PrintNFT() // call the function to mint an NFT
    await txn1.wait() // wait for NFT to be mined
    console.log("Minted NFT #1")

    let txn2 = await nftContract.mint10PrintNFT() // call the function to mint an NFT
    await txn2.wait() // wait for NFT to be mined
    console.log("Minted NFT #2")
};

const runMain = async () => { 
    try {
        await main();   // constructor runs when fully deployed
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();