"use client";

import React from "react";
import Link from "next/link";
import { SwitchTheme } from "~~/components/SwitchTheme";
import { RainbowKitCustomConnectButton } from "~~/components/scaffold-eth";

/**
 * Site header
 */
export const Header = () => {
  return (
    <div className="sticky lg:static top-0 navbar bg-base-100 min-h-0 flex-shrink-0 justify-between z-20 shadow-md shadow-secondary px-0 sm:px-2">
      <div className="navbar-start w-auto lg:w-1/2">
        <Link href="/" passHref className="lg:flex items-center gap-2 ml-4 mr-6 shrink-0">
          <div className="flex flex-row items-center gap-1">
            <span className="text-lg">🚨</span>
            <span className="font-bold leading-tight">FairDrop</span>
          </div>
        </Link>
      </div>
      <div className="navbar-end flex-grow mr-4">
        <RainbowKitCustomConnectButton />
        <div className="ml-2">
          <SwitchTheme />
        </div>
      </div>
    </div>
  );
};
