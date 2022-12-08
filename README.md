# Encode-Solidity-Bootcamp
Did the ETHDenver Solidity Bootcamp to improve my Solidity skills.

Prerequisites:  
[Foundry](https://github.com/foundry-rs/foundry)
[Git](https://git-scm.com/downloads)
[Alchemy](https://dashboard.alchemy.com/apps/)

> This repo to review the assignments I did during the ETHDenver Bootcamp powered by Encode

> For usage of this content beyond reviewing, please consult Encode:
https://www.encode.club/encode-bootcamps

# Highlights
Explanation of Final Project

https://github.com/PizzaHi5/Encode-Solidity-Bootcamp/blob/main/Homework_Files/1_FinalProject.txt    


Final Project

https://github.com/PizzaHi5/Encode-Solidity-Bootcamp/tree/main/src/Final-Project

# Getting Started
Download the repo
```
git clone https://github.com/PizzaHi5/Encode-Solidity-Bootcamp
```

Input your RPC URL in the <foundry.toml> file. 
https://github.com/PizzaHi5/Encode-Solidity-Bootcamp/blob/main/foundry.toml
Be sure you have a rpc url ready to go. I used Alchemy. Remove the # and copy/paste your url. The command will look like this:
```
# eth-rpc-url = "<your rpc url here>"
```
> Note: Some tests require forking mainnet to execute properly

Run all foundry tests 
```
forge test
```