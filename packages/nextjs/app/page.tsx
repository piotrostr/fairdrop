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
    case "Optimism":
      return <Image src="/optimism-logo.svg" alt="Optimism" width={24} height={24} />;
    case "Ethereum":
      return <Image src="/ethereum-logo.svg" alt="Ethereum" width={24} height={24} />;
  }
  return <>🔌</>;
};

const Home: NextPage = () => {
  const { address: connectedAddress, chain } = useAccount();
  const { data: fairDrop, isLoading } = useScaffoldContract({ contractName: "FairDrop" });
  const [isVerified, setIsVerified] = useState(false);

  useEffect(() => {
    if (!fairDrop || !connectedAddress) return;
    const checkIsVerified = async () => {
      const _isVerified = await fairDrop.read.isVerified([connectedAddress]);
      setIsVerified(_isVerified);
    };
    checkIsVerified();
  }, [fairDrop, isLoading, connectedAddress]);

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
                  <Address address={connectedAddress} />
                </div>
              </div>
              <div className="space-y-4">
                <div className="space-y-2">
                  <p className="font-medium text-base-content/70">FairDrop Address</p>
                  <Address address={fairDrop?.address} />
                </div>
              </div>
            </div>
            <div className="flex flex-col items-center justify-center space-y-8">
              {isLoading ? (
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
                    <div className="animate-pulse flex space-x-4 justify-center">
                      <div className="rounded-md bg-slate-300 h-6 w-6"></div>
                      <div className="flex items-center space-y-6">
                        <div className="h-2 w-28 bg-slate-300 rounded"></div>
                      </div>
                    </div>
                  )}
                </div>
              )}
            </div>
          </div>
        </div>
        {isVerified && (
          <div className="mt-8 text-center">
            <p className="text-xl font-semibold text-success">Congratulations! The verification was successful</p>
            <p className="mt-2 text-base-content/70">You can now proceed with using FairDrop.</p>
          </div>
        )}
      </main>
    </div>
  );
};

export default Home;
