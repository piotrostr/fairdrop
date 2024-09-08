#!/bin/bash

# Compile contracts
echo "Compiling contracts..."
forge build

# Deploy to Optimism
echo "Deploying to Optimism..."
forge script script/Deploy.s.sol \
    --rpc-url "$OPTIMISM_RPC_URL" \
    --broadcast \
    --legacy \
    --ffi \
    --froms $DEPLOYER_ADDRESS \
    --private-key $DEPLOYER_PRIVATE_KEY \
    --sender $DEPLOYER_ADDRESS

# Get the FairDrop address from the deployment
FAIRDROP_ADDRESS=$(grep -A1 '"FairDrop"' deployments/10.json | tail -n 1 | awk -F'"' '{print $2}')
export FAIRDROP_ADDRESS

# Deploy to Arbitrum
echo "Deploying to Arbitrum..."
forge script script/Deploy.s.sol \
    --rpc-url "$ARBITRUM_RPC_URL" \
    --broadcast \
    --legacy \
    --ffi \
    --froms $DEPLOYER_ADDRESS \
    --private-key $DEPLOYER_PRIVATE_KEY \
    --sender $DEPLOYER_ADDRESS

# Get the FairDropSatellite address from the deployment
FAIRDROP_SATELLITE_ADDRESS=$(grep -A1 '"FairDropSatellite"' deployments/42161.json | tail -n 1 | awk -F'"' '{print $2}')
export FAIRDROP_SATELLITE_ADDRESS

# Ensure artifacts are up to date
echo "Rebuilding artifacts..."
forge build

# Generate TypeScript ABIs
echo "Generating TypeScript ABIs..."
node scripts-js/generateTsAbis.js

echo "Deployment and ABI generation complete."
echo "FairDrop address on Optimism: $FAIRDROP_ADDRESS"
echo "FairDropSatellite address on Arbitrum: $FAIRDROP_SATELLITE_ADDRESS"
echo "Please set the verifier and receiver manually for both contracts."

