#!/bin/bash

forge script script/Deploy.s.sol \
    --rpc-url "https://opt-mainnet.g.alchemy.com/v2/$ALCHEMY_API_KEY" \
    --broadcast \
    --legacy \
    --ffi \
    --froms $DEPLOYER_ADDRESS \
    --private-key $DEPLOYER_PRIVATE_KEY && node scripts-js/generateTsAbis.js \
    --sender $DEPLOYER_ADDRESS