var account = "your address here";
var bytecode = "0x600a600c600039600a6000f3602a60005260206000f3";
await web3.eth.sendTransaction({ from: account, data: bytecode }, function(err,res){console.log(res)});

await contract.setSolver("0x742b873eea24a2ff9472e991ad1c57f400d218ab")

await contract.solver()