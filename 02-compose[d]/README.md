## compose[d]

`w`

`er`

`far`

`from`

`robot`

`n-also`

`from-an`

`assembly`

`of-noises`

`complexity`

`accumulates`

`and-directed`

`by-like-minds`

`scratches-left`

`permanently-set`

`tween-two-forces`

`order-compute-and`

`pure-stochasticity`

`composed-finds-path`

`simple-generator-f-s`

`sequenced-in-rhopalic`

`twelve-lines-in-thread`

`cullings-from-scratches`

`into-curious-expressions`

`echoes-data-memetic-minds`

`one-big-generator-function`

![WORD generations showing curious dalliances](../assets/word_gen_1.png?raw=True)

[WORD](https://ethwords.co/) is a canvas. 

From 2020 to today, 20,000+ textual tokens that emerged from the root tokens, just 28 elements on which all subsequent ones are based (a-z, space, -). This makes WORD a little microcosm of cultural evolution. How would tokens evolve, expand? Of course, degens and NFT fans do not simply produce new WORD tokens as a totally regular or completely random process. Token creation is culturally directed. It can be playful: One of the earliest tokens is a WORD asset of hundreds and hundreds of characters long, mostly with the alphabet in sequence. It can be profane: The 20,000+ tokens are a veritable minefield of questonable four-letter words and phrases. But it is also filled with subtle cultural references: *degens, mcdonalds, dapps, cryptodad, crypto-art, digital-art, halfinney, ...*. 

WORD is a directed cultural evolution, an echo of its place.

As such, it is a kind of collective poetry.

I work with data. I wanted to use WORD's data to express this poetry, this emergent process.

But I wanted to focus the output, into the parts of WORD that I found most interesting.

I used classic ideas from [Oulipo](https://en.wikipedia.org/wiki/Oulipo): systematic [poetry](https://twitter.com/MothersEthereum/status/1393619639377317888) under strict rules. The rules were simple, just little generator functions, which specify triples *F*(ID,skip,length). A generator function *F*(9316,4,4) would work like this: *Start at token ID 9316 then jump each 4 tokens 4 times.* It produces a suitable sequence for (mostly) 5-character items. 

*rubik (9316), habit (9321), geist (9325), false (9329), zeitgeist (9333)*

If I set 4 and 4 as standard value for 5-character generator functions, I can store **5 times as many WORD tokens with a single, simple generator function.**

I did this for all character lengths from 1 to 12 (choosing skip, length separately for each).

I extracted all 20,000 from the contract and found such triples that echoed some of the prominent trends in WORD: its growth from single characters to the semantics of phrases. I used a [rhopalism](https://www.merriam-webster.com/dictionary/rhopalic), perfectly suited to this expression, and found triples that *partially* reproduced this growth. Why partial rhopalic expressions? Because that is the growth of WORD itself (see graph above): departures from pure regularity and pure randomness. Divergences are highlighted in the outputs.

**And so the renderer contract itself is a generator function, an Oulipo of sorts.** 

![composed[d] as a standalone generator function](../assets/oulipo_F.png?raw=True)

I'm not its poet though. You are, we are. I just directed the generator function much as members of our curious little corner directed the cultural evolution of WORD.

It cost me about 3m gas to deploy these generator functions. Because the renderer can summon hundreds of WORD tokens, this generator function saves many times the gas used to build them (vs. about 14m gas). But if measured in rhopalic expressions - the outputs from the renderer - the expense is infinitesimal by comparison: **The renderer contract can produce over a trillion compositions**. 

I love when the chain gives us opportunities for conceptual recursions and self-reflections. But in an important sense this is not niche. WORD recapitulates the kind of divergence from neutral selection and other processes sometimes described in the study of biological and cultural evolution. The chain is just another medium through which the same principles diffuse and direct. 

### How can I mint?

**compose[d]** is part of [*Perpetual*](https://perpetual.takens.eth.limo), which uses a fully on-chain allowlist of prior collectors. You can find details on the main website. Mints are 0.005 ETH and all proceeds are sent automatically to GiveDirectly.

### Notes & Related Projects

* [WORD](https://ethwords.co/), of course
* Chainleft's [Chaos Roads](https://www.chainleft.art/chaos-roads) generates poetry in its innovative, groundbreaking multimodal outputs.
* [Etherpoems](https://opensea.io/collection/etherpoemsspokenword) (2021) is perhaps the archetypal poetry project on Ethereum.
* Many prominent poets on chain. Two favorites. See [Sasha Stiles](https://opensea.io/assets/ethereum/0x8fdde660c3ccab82756acc5233687a4ceb4b8f30/130). And for a prominent Oulipo example on Ethereum, see [Kalen Iwamoto](https://twitter.com/MothersEthereum/status/1393619639377317888) and their many structurally related works.

![Rhopalic expressions emanate from the generator function](../assets/rhops.png?raw=True)

