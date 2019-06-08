// Useful commands

// Get reference to a deployed contract
ChainList.deployed().then(function(instance){ app = instance; })

// Get balance for an account
web3.fromWei(web3.eth.getBalance(web3.eth.accounts[0]), "ether").toNumber()

// De la app específicamente
app.sellArticle("iPhone 7", "Selling in order to buy an iPhone 8", web3.toWei(3, "ether"), { from: web3.eth.accounts[1]})

// Compile contracts, deploy and reset
truffle migrate --compile-all --reset --network ganache

// Truffle console
truffle console --network ganache

// Start watching for an event
var sellEvent = app.LogSellArticle({}, {fromBlock: 0,toBlock: 'latest'}).watch(function(error, event){console.log(event)})

// Only the latest event (the normal): 
var sellEvent = app.LogSellArticle({}, {}).watch(function(error, event){console.log(event); })

