#!/bin/bash

# Ensure environment variables are set
if [ -z "$OPTIMISM_RPC_URL" ] || [ -z "$ARBITRUM_RPC_URL" ] || [ -z "$DEPLOYER_PRIVATE_KEY" ]; then
    echo "Error: Please set OPTIMISM_RPC_URL, ARBITRUM_RPC_URL, and DEPLOYER_PRIVATE_KEY environment variables."
    exit 1
fi

# Run the Sanity script
forge script script/Sanity.s.sol \
    --ffi \
    --private-key $DEPLOYER_PRIVATE_KEY
