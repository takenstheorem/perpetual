![path, wandering away; best wishes to you](assets/goodbye.png?raw=true)

# *Perpetual* by Takens Theorem

"Creator and collectors are now interwoven into a [little machine](https://perpetual.takens.eth.limo). And unlike its patrons, that little machine lives forever."

In this repository, I offer occasional reflections on *Perpetual*'s releases, community activities and so on. This information is on this centralized service and may not live forever. So the collector is also encouraged to visit the landing site [here](https://perpetual.takens.eth.limo), the coordinator contract or the most recent ERC-721 contract. These are listed below. Each subfolder of this repository contains notes about releases on *Perpetual*.

* Visit the [*Perpetual* landing site](https://perpetual.takens.eth.limo)
* [Coordinator contract](https://etherscan.io/address/0xf67d4aea92423f999cb3c1b4be979cc03968eda6#code)
* ERC-721 contract: [vol. 1](https://etherscan.io/address/0xbbcfcc50a2885495ab789e06bab7d8f85d2f73ce)
* OpenSea collections: [vol. 1](https://opensea.io/collection/perpetual-vol-1)

## Minting on Etherscan

_Perpetual_ is a machine and all its little experiments are on chain. You can call the contracts from any client. In two steps below, I illustrate how to mint on Etherscan. First, check if your token is ready. Second, mint.

### 1: Checking Eligibility & Readiness

In order to mint a *Perpetual* piece, you'll need to own an eligible prior work and that work should obey the coordinator contract's timing. You can check a given token by visiting the [coordinator contract](https://etherscan.io/address/0xf67d4aea92423f999cb3c1b4be979cc03968eda6#code) and clicking on the contract's read functions. 

![coordinator interface read illustration](assets/etherscan/read_coordinator.png?raw=true)

Under `mint_ready` supply the recipient address (your cold wallet, holding the prior work), the NFT address and the corresponding token. Here's an example with [my own token](https://opensea.io/assets/ethereum/0xf76c5d925b27a63a3745a6b787664a7f38fa79bd/1) from _the_coin_ (Oxf76...). At the time of this writing, my token #1 from _the_coin_ is ready to be used on *Perpetual*:

![illustrating checking if a work is ready to mint perpetual](assets/etherscan/mint_ready.png?raw=true)

The [*Perpetual* landing site](https://perpetual.takens.eth.limo) has a list of eligible projects.

### 2: Minting on *Perpetual*'s ERC-721

The minting function itself is available on the corresponding NFT contract (ERC-721: *Perpetual, vol. 1*). It is linked above and [right here](https://etherscan.io/address/0xbbcfcc50a2885495ab789e06bab7d8f85d2f73ce). Click on the contract and the write functions here:

![write function on nft contract](assets/etherscan/write_collection.png?raw=true)

Under `mint` supply the same details: owner wallet (recipient), NFT address (the prior work, the gate-keeping token) and the token ID. The current cost to mint is 0.005 ETH. **Important note: I strongly recommend always minting from a hot wallet; _Perpetual_ has this delegation built in, you can supply the cold wallet address but call the mint function from a hot wallet**. Here's an example for my _the_coin_ piece, as above.

![coordinator interface read illustration](assets/etherscan/mint.png?raw=true)

When the transaction is complete, you'll be able to click on the [transaction](https://etherscan.io/tx/0xf67ee3ffcc96b45df48a6f5682d3b42848721e6cd744111e0a6404f10779bd95) and see the new _Perpetual_ mint. 

![transaction details](assets/etherscan/mint_example.png?raw=true)

Etherscan may take a few seconds to update the appearance of [that asset](https://etherscan.io/nft/0xbbcfcc50a2885495ab789e06bab7d8f85d2f73ce/206) on its website. 

![viewing asset on etherscan](assets/etherscan/mint_show.png?raw=true)
