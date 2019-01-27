await contract.allowance(player,player)
await contract.approve(player, (await contract.INITIAL_SUPPLY()).toNumber())
await contract.transferFrom(player, [_3rd_contract_address], (await contract.INITIAL_SUPPLY()).toNumber())
await contract.allowance(player,player)