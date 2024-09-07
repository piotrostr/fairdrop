import Image from "next/image";
import { IDKitWidget, ISuccessResult } from "@worldcoin/idkit";
import { decodeAbiParameters } from "viem";
import { useAccount } from "wagmi";
import { useScaffoldWriteContract, useTargetNetwork } from "~~/hooks/scaffold-eth";

const WORLD_COIN_APP_ID = "app_9f3c3c467dbfb7c616671b1b07c3f221";
const WORLD_COIN_ACTION_ID = "verify";

export const WorldCoinVerification = () => {
  const { address, chain } = useAccount();
  const { targetNetwork } = useTargetNetwork();
  const { writeContractAsync: fairDrop, isPending } = useScaffoldWriteContract("FairDrop");

  const onSuccess = async (result: ISuccessResult) => {
    const unpackedProof = decodeAbiParameters([{ type: "uint256[8]" }], result.proof as `0x${string}`)[0];
    console.log("submitting for on chain verification:", result);
    if (!address) return;

    try {
      const res = await fairDrop(
        {
          functionName: "verifyAndPropagate",
          args: [address, BigInt(result.merkle_root), BigInt(result.nullifier_hash), unpackedProof],
        },
        {
          onBlockConfirmation: txnReceipt => {
            console.log("📦 receipt", txnReceipt);
          },
        },
      );
      console.log("on chain verification result:", res);
    } catch (e) {
      console.error("Error verifying with World ID", e);
    }
  };

  const disabled =
    chain?.id !== targetNetwork.id || isPending || chain?.name === "Arbitrum One" || chain?.name === "Foundry";

  return (
    <IDKitWidget
      app_id={WORLD_COIN_APP_ID}
      action={WORLD_COIN_ACTION_ID}
      signal={address}
      onSuccess={onSuccess}
      autoClose={true}
    >
      {({ open }) => (
        <WorldCoinButton
          onClick={open}
          disabled={disabled}
          text={isPending ? "Verifying..." : "Verify with World ID"}
        />
      )}
    </IDKitWidget>
  );
};

interface WorldCoinButtonProps {
  onClick: () => void;
  disabled: boolean;
  text: string;
}

const WorldCoinButton = ({ onClick, disabled, text }: WorldCoinButtonProps) => (
  <button
    className="bg-black text-white hover:bg-gray-800 px-6 py-3 rounded-full font-semibold text-lg transition-all duration-300 ease-in-out transform hover:scale-105 focus:outline-none focus:ring-2 focus:ring-gray-400 focus:ring-opacity-50 shadow-lg flex items-center justify-center space-x-2 disabled:opacity-50 disabled:cursor-not-allowed border-2 dark:border-white light:border-black"
    onClick={onClick}
    disabled={disabled}
  >
    <span>{text}</span>
    <Image src="/world-coin-logo.svg" alt="WorldCoin" className="h-6 w-6" width="24" height="24" />
  </button>
);
