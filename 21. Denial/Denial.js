await contract.contractBalance()
await contract.setWithdrawPartner(0x5e1078ab3a33efbbd6bb28bacd44d3e4c2ae69bf)
await contract.withdraw()
await contract.contractBalance()