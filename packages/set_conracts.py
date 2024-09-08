from web3 import Web3
import os

# Updated Contract ABI (replace with your actual ABI)
ABI = [
    {
        "inputs": [
            {"internalType": "uint16", "name": "_receiverChainId", "type": "uint16"},
            {"internalType": "address", "name": "_receiverAddress", "type": "address"},
        ],
        "name": "setReceiver",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function",
    },
    {
        "inputs": [
            {"internalType": "uint16", "name": "_verifierChainId", "type": "uint16"},
            {"internalType": "address", "name": "_verifierAddress", "type": "address"},
        ],
        "name": "setVerifier",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function",
    },
]

# Contract addresses (replace with your actual contract addresses)
OPTIMISM_CONTRACT_ADDRESS = Web3.to_checksum_address(
    "0x859a661a05c3f2fbec2f08a9d2656f0092b3ce7a"
)
ARBITRUM_CONTRACT_ADDRESS = Web3.to_checksum_address(
    "0xEb98b67D22c2B105891a20f337Bf2b185A8ceee8"
)

# Network RPC URLs
OPTIMISM_RPC_URL = os.getenv("OPTIMISM_RPC_URL")
ARBITRUM_RPC_URL = os.getenv("ARBITRUM_RPC_URL")

# Private key
DEPLOYER_PRIVATE_KEY = os.getenv("DEPLOYER_PRIVATE_KEY")

# Function to call setReceiver
# def set_receiver(web3, contract_address, chain_id, receiver_chain_id, receiver_address):
#     # ... (keep the existing set_receiver function as it is)


# New function to call setVerifier
def set_verifier(web3, contract_address, chain_id, verifier_chain_id, verifier_address):
    contract = web3.eth.contract(address=contract_address, abi=ABI)

    # Prepare transaction
    transaction = contract.functions.setVerifier(
        verifier_chain_id, verifier_address
    ).build_transaction(
        {
            "chainId": chain_id,
            "gas": 200000,
            "gasPrice": web3.eth.gas_price,
            "nonce": web3.eth.get_transaction_count(
                web3.eth.account.from_key(DEPLOYER_PRIVATE_KEY).address
            ),
        }
    )
    print(f"Transaction prepared on chain {chain_id}")
    # print params
    print("verifier_chain_id", verifier_chain_id)
    print("verifier_address", verifier_address)
    print("signer address", web3.eth.account.from_key(DEPLOYER_PRIVATE_KEY).address)
    print(transaction)

    # Sign and send transaction
    signed_txn = web3.eth.account.sign_transaction(transaction, DEPLOYER_PRIVATE_KEY)
    tx_hash = web3.eth.send_raw_transaction(signed_txn.raw_transaction)

    # Wait for transaction receipt
    tx_receipt = web3.eth.wait_for_transaction_receipt(tx_hash)
    print(
        f"Transaction successful on chain {chain_id}. Transaction hash: {tx_receipt.transactionHash.hex()}"
    )


if __name__ == "__main__":
    # Set up Web3 instances
    optimism_web3 = Web3(Web3.HTTPProvider(OPTIMISM_RPC_URL))
    arbitrum_web3 = Web3(Web3.HTTPProvider(ARBITRUM_RPC_URL))

    # Example values for setReceiver (replace with your actual values)
    receiver_chain_id = 42161
    receiver_address = ARBITRUM_CONTRACT_ADDRESS

    # Example values for setVerifier (replace with your actual values)
    verifier_chain_id = 10  # Assuming Optimism chain ID
    verifier_address = OPTIMISM_CONTRACT_ADDRESS

    # Call setReceiver on Optimism
    # set_receiver(
    #     optimism_web3,
    #     OPTIMISM_CONTRACT_ADDRESS,
    #     10,
    #     receiver_chain_id,
    #     receiver_address,
    # )

    # Call setReceiver on Arbitrum
    # set_receiver(
    #     arbitrum_web3, ARBITRUM_CONTRACT_ADDRESS, 42161, receiver_chain_id, receiver_address
    # )

    # Call setVerifier on Arbitrum
    set_verifier(
        arbitrum_web3,
        ARBITRUM_CONTRACT_ADDRESS,
        42161,
        verifier_chain_id,
        verifier_address,
    )
