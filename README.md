# 10 Print NFT

A generative art NFT project, inspired by 10 PRINT CHR$(205.5+RND(1)); : GOTO 10, the one-line Commodore 64 BASIC program.

https://www.stevekennedy.io/about/10-print-nft

The Ethereum smart contract procedurally generates each NFT as an SVG. While the image would typically be stored elsewhere and only the hash stored, this project stores the image data entirely on-chain as an experiment of what is possible within the stringent limits on Ethereum contract size.

This project is built using Hardhat. To deploy:
- Set the staging/production environment in hardhat.config.js
- Run ``npx hardhat run scripts/deploy.js ``, noting you can set the network with the  ``--network`` option.
