const ethers = require("ethers");
const abi = require('./abi.json');

const wssUrl = "wss://eth-mainnet.g.alchemy.com/v2/code here";
const router = "0xE592427A0AEce92De3Edee1F18E0157C05861564"; //Uniswap v3 SwapRouter

const interface = new ethers.utils.Interface(abi);

async function main() {
    const provider = new ethers.providers.WebSocketProvider(wssUrl);
    provider.on('pending', async(tx) => {
        const txnData = await provider.getTransaction(tx);
        if (txnData) {
            let gas = txnData['gasPrice'];
            if (txnData.to == router && txnData['data'].includes("0x414bf389")) {
                console.log("hash: ", txnData['hash']);
                let decoded = interface.decodeFunctionData("exactInputSingle((address,address,uint24,address,uint256,uint256,uint256,uint160))", txnData['data']);
                logTxn(decoded, gas);
            }
        }
    })
}

async function logTxn(data, gas) {
    console.log("tokenIn: ", data['params']['tokenIn']);
    console.log("tokenOut: ", data['params']['tokenOut']);
    console.log("amount: ", data['params']['amountOutMinimum'].toString());
    console.log("gasPrice: ", gas.toString());
    console.log("-------------");
}

main();