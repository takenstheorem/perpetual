![Mixing molecules into stuff](../assets/chemwide.png?raw=True)

### Release 3
# Filtered

Conceptual inspiration for this little project derives from the conniving relationship between randomness and structure.
The universe is composed of seemingly infinite randomly moving particles, under varying laws that yield motion
to and fro. But somehow, these elements clump. They form patterns. Through the filter of physical law, thermodynamics
of open systems and local interaction and more, they bring about gradients, cellular forms, patches of 
recognizable something.

"Filtered" is a little illustration of this. Each token is a raw bitmap generated on the contract. The token
operates over the most recent minute of computation in Ethereum's [block hashes](https://ethereum.org/en/developers/docs/blocks/). These block hashes are seemingly
random. They're actually, and by necessity, deterministically connected. They link the entire history of 
the ledger we use. The apparent randomness of block hashes
can be given structure from the "laws" coded on the "Filtered" rendering contract. 

From randomness, pattern. Local interactions. Gradients. Cellular structure. Flows. 

![Some filters...](../assets/some_filters.png?raw=True)

## More detail

"Filtered" tokens function as... a filter through which the most recent history of our ledger passes. 
This critical history, connecting its entire history of computation, involves the block hash values 
of the previous 5 blocks, encompassing one minute's worth of computational activity. 

`The tokens are dynamic, a moving window yielding pattern from apparent randomness of each passing block hash.`

Each asset defines its filter by referring to the token number. The filter then examines the moving 
average of this minute worth of block hashes. It then uses values derived from the block hashes to define color and intensity. 

"Filtered" demonstrates how apparent randomness can yield structure. The filter highlights specific positions 
and colors within the data. The outputs across filters vary, with some exhibiting vibrant, 
multi-colored patterns, others emphasizing particular color values, and still others displaying more 
subdued and subtle hues. 

The filtered data is then passed to a 10x10 bitmap, resulting in 100 RGB values that are computed 
directly on the contract, generating a raw image file. In the metadata, this bitmap is scaled to a 1000x1000-pixel SVG. 
All this technical detail was inspired by these two wonderful projects that used related techniques years ago: [Mandalas](https://mandalas.eth.limo/) and [Brotchain](https://brotchain.art/).

Some have referred to this bitmap generation as "in-chain," an intriguing
designation for [EVM](https://ethereum.org/en/developers/docs/evm/) compute that produces a raw image requiring little processing. Bitmaps are suitable for this purpose. It may be more helpful to emphasize the specific filtering process: 

`The contract computes a colorful representation of one minute of recent history, expressed as a little bitmap. This flowing, structured, and moving average then transitions from block to block. From randomness, something.`

## A few more technical notes

Owners can [view and progress](https://x.com/miragenesi/status/1813233172944932911) their "Filtered" tokens on the [Perpetual main site](https://perpetual.takens.eth.limo). 
Click under
"Example mints" and you can enter your filter token ID. You should see a slightly new visual, a "visual moving average," when you click "view" at each new block -- at 12-second intervals.

I tuned the filter myself, aiming for a few layers of the filter through which the block hashes pass. Using 
modular arithmetic makes it fairly straightforward, but most time is spent tuning its specific "laws"
that use this simple mathematical method. There are a number of little touches that I won't disclose
in words. You can peruse the renderer's code if you wish. I hope you find it neat and fun. I did.
