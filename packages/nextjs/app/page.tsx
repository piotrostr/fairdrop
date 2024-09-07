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
          <div className="flex flex-col items-center space-y-4 mb-6">
            <div className="font-medium">
              <div className="mt-3">
                Address: <Address address={connectedAddress} />
              </div>
              <div className="mt-3">
                Chain:{" "}
                {chain?.id ? (
                  <div className="flex flex-row font-normal items-center">
                    <div>{chain?.name ? ChainNameToLogo(chain.name) : ""}</div>
                    <div className="ml-1.5">{chain?.name}</div>
                    <div className="ml-1">{chain?.id ? "(ID: " + chain.id + ")" : ""}</div>
                  </div>
                ) : (
                  <div className="animate-pulse flex space-x-4">
                    <div className="rounded-md bg-slate-300 h-6 w-6"></div>
                    <div className="flex items-center space-y-6">
                      <div className="h-2 w-28 bg-slate-300 rounded"></div>
                    </div>
                  </div>
                )}
              </div>
              <div className="mt-3">
                FairDrop Address: <Address address={fairDrop?.address} />
              </div>
            </div>
          </div>

          <div className="flex justify-center">
            {isLoading ? (
              <span className="loading loading-spinner loading-lg"></span>
            ) : isVerified ? (
              <div className="flex items-center text-success">
                <ShieldCheckIcon className="h-8 w-8 mr-2" />
                <span className="text-xl font-semibold">Verified!</span>
              </div>
            ) : (
              <WorldCoinVerification />
            )}
          </div>
        </div>

        {isVerified && (
          <div className="mt-8 text-center">
            <p className="text-lg">Congratulations! The verification was successful</p>
          </div>
        )}
      </main>
    </div>
  );
};

export default Home;
