/**
 * This file is autogenerated by Scaffold-ETH.
 * You should not edit it manually or your changes might be overwritten.
 */
import { GenericContractsDeclaration } from "~~/utils/scaffold-eth/contract";

const deployedContracts = {
  10: {
    FairDrop: {
      address: "0x859a661a05c3f2fbec2f08a9d2656f0092b3ce7a",
      abi: [
        {
          type: "constructor",
          inputs: [
            {
              name: "_worldId",
              type: "address",
              internalType: "address",
            },
            {
              name: "_appId",
              type: "string",
              internalType: "string",
            },
            {
              name: "_actionId",
              type: "string",
              internalType: "string",
            },
            {
              name: "_wormholeRelayer",
              type: "address",
              internalType: "address",
            },
            {
              name: "_chainId",
              type: "uint16",
              internalType: "uint16",
            },
          ],
          stateMutability: "nonpayable",
        },
        {
          type: "function",
          name: "chainId",
          inputs: [],
          outputs: [
            {
              name: "",
              type: "uint16",
              internalType: "uint16",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "getDeliveryQuote",
          inputs: [
            {
              name: "receiverValue",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          outputs: [
            {
              name: "cost",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "isVerified",
          inputs: [
            {
              name: "_address",
              type: "address",
              internalType: "address",
            },
          ],
          outputs: [
            {
              name: "",
              type: "bool",
              internalType: "bool",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "receiverAddress",
          inputs: [],
          outputs: [
            {
              name: "",
              type: "address",
              internalType: "address",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "receiverChainId",
          inputs: [],
          outputs: [
            {
              name: "",
              type: "uint16",
              internalType: "uint16",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "setReceiver",
          inputs: [
            {
              name: "_receiverChainId",
              type: "uint16",
              internalType: "uint16",
            },
            {
              name: "_receiverAddress",
              type: "address",
              internalType: "address",
            },
          ],
          outputs: [],
          stateMutability: "nonpayable",
        },
        {
          type: "function",
          name: "verified",
          inputs: [
            {
              name: "",
              type: "address",
              internalType: "address",
            },
          ],
          outputs: [
            {
              name: "",
              type: "bool",
              internalType: "bool",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "verifyAndPropagate",
          inputs: [
            {
              name: "signal",
              type: "address",
              internalType: "address",
            },
            {
              name: "root",
              type: "uint256",
              internalType: "uint256",
            },
            {
              name: "nullifierHash",
              type: "uint256",
              internalType: "uint256",
            },
            {
              name: "proof",
              type: "uint256[8]",
              internalType: "uint256[8]",
            },
          ],
          outputs: [],
          stateMutability: "payable",
        },
        {
          type: "function",
          name: "worldId",
          inputs: [],
          outputs: [
            {
              name: "",
              type: "address",
              internalType: "contract IWorldID",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "wormholeRelayer",
          inputs: [],
          outputs: [
            {
              name: "",
              type: "address",
              internalType: "contract IWormholeRelayer",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "event",
          name: "ReceiverSet",
          inputs: [
            {
              name: "chainId",
              type: "uint16",
              indexed: false,
              internalType: "uint16",
            },
            {
              name: "receiverAddress",
              type: "address",
              indexed: false,
              internalType: "address",
            },
          ],
          anonymous: false,
        },
        {
          type: "event",
          name: "SentForDelivery",
          inputs: [
            {
              name: "timestamp",
              type: "uint256",
              indexed: false,
              internalType: "uint256",
            },
            {
              name: "deliveryQuote",
              type: "uint256",
              indexed: false,
              internalType: "uint256",
            },
            {
              name: "payloadLength",
              type: "uint256",
              indexed: false,
              internalType: "uint256",
            },
          ],
          anonymous: false,
        },
        {
          type: "event",
          name: "Verified",
          inputs: [
            {
              name: "nullifierHash",
              type: "uint256",
              indexed: false,
              internalType: "uint256",
            },
          ],
          anonymous: false,
        },
        {
          type: "error",
          name: "DuplicateNullifier",
          inputs: [
            {
              name: "nullifierHash",
              type: "uint256",
              internalType: "uint256",
            },
          ],
        },
        {
          type: "error",
          name: "ReceiverAlreadySet",
          inputs: [],
        },
      ],
      inheritedFunctions: {},
    },
  },
  31337: {
    FairDrop: {
      address: "0x8ce361602b935680e8dec218b820ff5056beb7af",
      abi: [
        {
          type: "constructor",
          inputs: [
            {
              name: "_worldId",
              type: "address",
              internalType: "address",
            },
            {
              name: "_appId",
              type: "string",
              internalType: "string",
            },
            {
              name: "_actionId",
              type: "string",
              internalType: "string",
            },
            {
              name: "_wormholeRelayer",
              type: "address",
              internalType: "address",
            },
            {
              name: "_chainId",
              type: "uint16",
              internalType: "uint16",
            },
          ],
          stateMutability: "nonpayable",
        },
        {
          type: "function",
          name: "chainId",
          inputs: [],
          outputs: [
            {
              name: "",
              type: "uint16",
              internalType: "uint16",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "getDeliveryQuote",
          inputs: [
            {
              name: "receiverValue",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          outputs: [
            {
              name: "cost",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "isVerified",
          inputs: [
            {
              name: "_address",
              type: "address",
              internalType: "address",
            },
          ],
          outputs: [
            {
              name: "",
              type: "bool",
              internalType: "bool",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "receiverAddress",
          inputs: [],
          outputs: [
            {
              name: "",
              type: "address",
              internalType: "address",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "receiverChainId",
          inputs: [],
          outputs: [
            {
              name: "",
              type: "uint16",
              internalType: "uint16",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "setReceiver",
          inputs: [
            {
              name: "_receiverChainId",
              type: "uint16",
              internalType: "uint16",
            },
            {
              name: "_receiverAddress",
              type: "address",
              internalType: "address",
            },
          ],
          outputs: [],
          stateMutability: "nonpayable",
        },
        {
          type: "function",
          name: "verified",
          inputs: [
            {
              name: "",
              type: "address",
              internalType: "address",
            },
          ],
          outputs: [
            {
              name: "",
              type: "bool",
              internalType: "bool",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "verifyAndPropagate",
          inputs: [
            {
              name: "signal",
              type: "address",
              internalType: "address",
            },
            {
              name: "root",
              type: "uint256",
              internalType: "uint256",
            },
            {
              name: "nullifierHash",
              type: "uint256",
              internalType: "uint256",
            },
            {
              name: "proof",
              type: "uint256[8]",
              internalType: "uint256[8]",
            },
          ],
          outputs: [],
          stateMutability: "payable",
        },
        {
          type: "function",
          name: "worldId",
          inputs: [],
          outputs: [
            {
              name: "",
              type: "address",
              internalType: "contract IWorldID",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "wormholeRelayer",
          inputs: [],
          outputs: [
            {
              name: "",
              type: "address",
              internalType: "contract IWormholeRelayer",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "event",
          name: "ReceiverSet",
          inputs: [
            {
              name: "chainId",
              type: "uint16",
              indexed: false,
              internalType: "uint16",
            },
            {
              name: "receiverAddress",
              type: "address",
              indexed: false,
              internalType: "address",
            },
          ],
          anonymous: false,
        },
        {
          type: "event",
          name: "SentForDelivery",
          inputs: [
            {
              name: "timestamp",
              type: "uint256",
              indexed: false,
              internalType: "uint256",
            },
            {
              name: "deliveryQuote",
              type: "uint256",
              indexed: false,
              internalType: "uint256",
            },
            {
              name: "payloadLength",
              type: "uint256",
              indexed: false,
              internalType: "uint256",
            },
          ],
          anonymous: false,
        },
        {
          type: "event",
          name: "Verified",
          inputs: [
            {
              name: "nullifierHash",
              type: "uint256",
              indexed: false,
              internalType: "uint256",
            },
          ],
          anonymous: false,
        },
        {
          type: "error",
          name: "DuplicateNullifier",
          inputs: [
            {
              name: "nullifierHash",
              type: "uint256",
              internalType: "uint256",
            },
          ],
        },
        {
          type: "error",
          name: "ReceiverAlreadySet",
          inputs: [],
        },
      ],
      inheritedFunctions: {},
    },
  },
  42161: {
    FairDropSatellite: {
      address: "0xeb98b67d22c2b105891a20f337bf2b185a8ceee8",
      abi: [
        {
          type: "constructor",
          inputs: [
            {
              name: "_chainId",
              type: "uint16",
              internalType: "uint16",
            },
          ],
          stateMutability: "nonpayable",
        },
        {
          type: "function",
          name: "OPTIMISM_CHAIN_ID",
          inputs: [],
          outputs: [
            {
              name: "",
              type: "uint16",
              internalType: "uint16",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "chainId",
          inputs: [],
          outputs: [
            {
              name: "",
              type: "uint16",
              internalType: "uint16",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "isVerified",
          inputs: [
            {
              name: "user",
              type: "address",
              internalType: "address",
            },
          ],
          outputs: [
            {
              name: "",
              type: "bool",
              internalType: "bool",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "receiveWormholeMessages",
          inputs: [
            {
              name: "payload",
              type: "bytes",
              internalType: "bytes",
            },
            {
              name: "",
              type: "bytes[]",
              internalType: "bytes[]",
            },
            {
              name: "sourceAddress",
              type: "bytes32",
              internalType: "bytes32",
            },
            {
              name: "sourceChain",
              type: "uint16",
              internalType: "uint16",
            },
            {
              name: "",
              type: "bytes32",
              internalType: "bytes32",
            },
          ],
          outputs: [],
          stateMutability: "payable",
        },
        {
          type: "function",
          name: "setVerifier",
          inputs: [
            {
              name: "_verifierChainId",
              type: "uint16",
              internalType: "uint16",
            },
            {
              name: "_verifierAddress",
              type: "address",
              internalType: "address",
            },
          ],
          outputs: [],
          stateMutability: "nonpayable",
        },
        {
          type: "function",
          name: "usedNullifiers",
          inputs: [
            {
              name: "",
              type: "uint256",
              internalType: "uint256",
            },
          ],
          outputs: [
            {
              name: "",
              type: "bool",
              internalType: "bool",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "verifiedUsers",
          inputs: [
            {
              name: "",
              type: "address",
              internalType: "address",
            },
          ],
          outputs: [
            {
              name: "",
              type: "bool",
              internalType: "bool",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "verifierAddress",
          inputs: [],
          outputs: [
            {
              name: "",
              type: "address",
              internalType: "address",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "function",
          name: "verifierChainId",
          inputs: [],
          outputs: [
            {
              name: "",
              type: "uint16",
              internalType: "uint16",
            },
          ],
          stateMutability: "view",
        },
        {
          type: "event",
          name: "VerificationPropagated",
          inputs: [
            {
              name: "timestamp",
              type: "uint256",
              indexed: false,
              internalType: "uint256",
            },
            {
              name: "user",
              type: "address",
              indexed: false,
              internalType: "address",
            },
            {
              name: "nullifierHash",
              type: "uint256",
              indexed: false,
              internalType: "uint256",
            },
          ],
          anonymous: false,
        },
        {
          type: "event",
          name: "VerifierSet",
          inputs: [
            {
              name: "chainId",
              type: "uint16",
              indexed: false,
              internalType: "uint16",
            },
            {
              name: "verifierAddress",
              type: "address",
              indexed: false,
              internalType: "address",
            },
          ],
          anonymous: false,
        },
        {
          type: "error",
          name: "VerifierAlreadySet",
          inputs: [],
        },
      ],
      inheritedFunctions: {},
    },
  },
} as const;

export default deployedContracts satisfies GenericContractsDeclaration;
