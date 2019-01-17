web3Provider = new Web3.providers.HttpProvider('https://ropsten.infura.io/');
web3 = new Web3(web3Provider);
await web3.eth.getStorageAt(contract.address, 0)
await web3.eth.getStorageAt(contract.address, 1)
await web3.eth.getStorageAt(contract.address, 2)
await web3.eth.getStorageAt(contract.address, 3)
await web3.eth.getStorageAt(contract.address, 4)
await contract.unlock(web3.toAscii('0x7c8826cea6098e4eafaaede1d3325e8b'))
await contract.locked