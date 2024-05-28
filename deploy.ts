import { ethers } from "ethers";
import fs from "fs";
import path from "path"

async function main() {
    const provider = new ethers.JsonRpcProvider("http://0.0.0.0:7545");
    const wallet = new ethers.Wallet("0x67696b0123b6973607031bf8e896f3c33897f606b39c709b79e3e268b484fb22", provider);

    const abi = fs.readFileSync(path.join(__dirname, "./solidity/SimpleStorage_sol_SimpleStorage.abi"), "utf8").toString();
    const binary = fs.readFileSync(path.join(__dirname, "./solidity/SimpleStorage_sol_SimpleStorage.bin"), "utf8");

    const contractFactory = new ethers.ContractFactory<any, {
        persons: (index: string) => number;
        store: (age: string, name: string) => void;
    }>(abi, binary, wallet);
    console.log("Deploying contract!");
    const contract = await contractFactory.deploy();
    await contract.deploymentTransaction()?.wait(1)

    // const tx: ethers.TransactionRequest = {
    //     nonce: await wallet.getNonce(),
    //     gasPrice: 20000000000,
    //     gasLimit: 1000000,
    //     to: null,
    //     value: 0,
    //     data: `0x${binary}`,
    //     chainId: 1337,
    // };

    // const sentTxResponse = await wallet.sendTransaction(tx);
    // await sentTxResponse.wait(1);

    // console.log(sentTxResponse)
    await contract.store("34", "toto");

    console.log(await contract.persons("0"));
}

main();