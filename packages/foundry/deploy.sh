#!/bin/bash


# Deploy to Optimism
forge script script/Deploy.s.sol \
    --rpc-url "$OPTIMISM_RPC_URL" \
    --broadcast \
    --legacy \
    --ffi \
    --froms $DEPLOYER_ADDRESS \
    --private-key $DEPLOYER_PRIVATE_KEY \
    --sender $DEPLOYER_ADDRESS

# Deploy to Arbitrum
forge script script/Deploy.s.sol \
    --rpc-url "$ARBITRUM_RPC_URL" \
    --broadcast \
    --legacy \
    --ffi \
    --froms $DEPLOYER_ADDRESS \
    --private-key $DEPLOYER_PRIVATE_KEY \
    --sender $DEPLOYER_ADDRESS

# Generate TypeScript ABIs
node scripts-js/generateTsAbis.js
