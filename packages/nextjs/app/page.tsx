"use client";

import { useEffect, useState } from "react";
import Image from "next/image";
import type { NextPage } from "next";
import { useAccount } from "wagmi";
import { ShieldCheckIcon } from "@heroicons/react/24/outline";
import { WorldCoinVerification } from "~~/components/WorldCoinVerification";
import { Address } from "~~/components/scaffold-eth";
import { useScaffoldContract } from "~~/hooks/scaffold-eth";

const ChainNameToLogo = (chainId: string) => {
  switch (chainId) {
    case "Foundry":
      return <Image src="/foundry-logo.png" alt="Foundry" width={24} height={24} />;
    case "OP Mainnet":
      return <Image src="/optimism-logo.svg" alt="Optimism" width={24} height={24} />;
    case "Ethereum":
      return <Image src="/ethereum-logo.svg" alt="Ethereum" width={24} height={24} />;
    case "Arbitrum One":
      return <Image src="/arbitrum-logo.svg" alt="Arbitrum" width={24} height={24} />;
  }
  return <>🔌</>;
};

const Home: NextPage = () => {
  const { address: connectedAddress, chain, isConnecting } = useAccount();
  const { data: fairDrop, isLoading } = useScaffoldContract({ contractName: "FairDrop" });
  const { data: fairDropSatellite, isLoading: isLoadingSatellite } = useScaffoldContract({
    // @ts-ignore, some typing shenanigans, this does exist in `../contracts/deployedContracts.ts` tho
    contractName: "FairDropSatellite",
  });
  const [isVerified, setIsVerified] = useState(false);
  const [isVerifiedSatellite, setIsVerifiedSatellite] = useState(false);

  useEffect(() => {
    if (!fairDrop || !connectedAddress || isVerified) return;
    const checkIsVerified = async () => {
      console.log("Checking if verified");
      const _isVerified = await fairDrop.read.isVerified([connectedAddress]);
      setIsVerified(_isVerified);
    };
    checkIsVerified();
  }, [fairDrop, isLoading, connectedAddress, isVerified]);

  useEffect(() => {
    if (!fairDropSatellite || !connectedAddress) return;
    const checkIsVerifiedSatellite = async () => {
      console.log("Checking if verified satellite");
      const _isVerifiedSatellite = await fairDropSatellite.read.isVerified([connectedAddress]);
      setIsVerifiedSatellite(_isVerifiedSatellite);
    };
    checkIsVerifiedSatellite();
  }, [fairDropSatellite, isLoadingSatellite, connectedAddress]);

  return (
    <div className="flex flex-col items-center justify-center flex-grow bg-gradient-to-b from-base-200 to-base-300 px-4 py-12">
      <main className="flex flex-col items-center w-full max-w-2xl">
        <div className="bg-base-100 rounded-lg shadow-xl p-8 w-full">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
            <div className="space-y-8">
              <div className="space-y-4">
                <h2 className="text-2xl font-semibold">Account Information</h2>
                <div className="space-y-2">
                  <p className="font-medium text-base-content/70">Connected Address</p>
                  {connectedAddress ? (
                    <Address address={connectedAddress} />
                  ) : (
                    <>
                      {isLoading ? (
                        <Address address={connectedAddress} />
                      ) : (
                        <span className="text-error">Wallet not connected</span>
                      )}
                    </>
                  )}
                </div>
              </div>
              <div className="space-y-4">
                <div className="space-y-2">
                  {chain?.name === "Arbitrum One" ? (
                    <>
                      <p className="font-medium text-base-content/70">FairDrop Satellite Address</p>
                      <Address address={fairDropSatellite?.address} />
                    </>
                  ) : (
                    <>
                      <p className="font-medium text-base-content/70">FairDrop Address</p>
                      <Address address={fairDrop?.address} />
                    </>
                  )}
                </div>
              </div>
            </div>
            <div className="flex flex-col items-center justify-center space-y-8">
              {isLoading || isConnecting ? (
                <span className="loading loading-spinner loading-lg"></span>
              ) : isVerified ? (
                <div className="flex flex-col items-center text-success">
                  <ShieldCheckIcon className="h-16 w-16" />
                  <span className="text-2xl font-semibold">Verified!</span>
                </div>
              ) : (
                <div>
                  <WorldCoinVerification />
                  {chain?.id ? (
                    <div className="flex flex-row items-center justify-center mt-3">
                      <div>{chain?.name ? ChainNameToLogo(chain.name) : ""}</div>
                      <div className="ml-2 font-medium">{chain?.name}</div>
                      <div className="ml-2 text-sm text-base-content/70">
                        {chain?.id ? "(ID: " + chain.id + ")" : ""}
                      </div>
                    </div>
                  ) : (
                    <>
                      {isConnecting ? (
                        <div className="animate-pulse flex space-x-4 justify-center">
                          <div className="rounded-md bg-slate-300 h-6 w-6"></div>
                          <div className="flex items-center space-y-6">
                            <div className="h-2 w-28 bg-slate-300 rounded"></div>
                          </div>
                        </div>
                      ) : null}
                    </>
                  )}
                </div>
              )}
            </div>
          </div>
        </div>
        {chain?.name === "Arbitrum One" ? (
          <>
            {isVerifiedSatellite && (
              <div className="mt-8 text-center">
                <p className="text-xl font-semibold text-success">You are verified on Arbitrum too</p>
                <p className="mt-2 text-base-content/70">Nice</p>
              </div>
            )}
          </>
        ) : (
          <>
            {isVerified && (
              <div className="mt-8 text-center">
                <p className="text-xl font-semibold text-success">
                  Congratulations! The verification was successful on Optimism
                </p>
                <p className="mt-2 text-base-content/70">Your ID has been cross-chain populated to Arbitrum</p>
              </div>
            )}
          </>
        )}
      </main>
    </div>
  );
};

export default Home;
