web3Provider = new Web3.providers.HttpProvider('https://ropsten.infura.io/');
web3 = new Web3(web3Provider);
web3.toAscii(web3.eth.getStorageAt(contract.address,1))
contract.unlock('A very strong secret password :)')
contract.locked()