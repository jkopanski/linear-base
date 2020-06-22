{ sources ? import ./nix/sources.nix }:

let
  haskellNix = import sources."haskell.nix" {};
  nixpkgs = import sources.nixpkgs haskellNix.nixpkgsArgs;
  haskell = nixpkgs.haskell-nix;

  pkgSet = haskell.mkCabalProjectPkgSet {
    plan-pkgs = import ./pkgs.nix;
    pkg-def-extras = [];
    modules = [
      { packages.lifted-async.patches = [ ./patches/lifted-async-0.10.0.6.patch ]; }
      { packages."QuickCheck".patches = [ ./patches/QuickCheck-2.14.patch ]; }
    ];
  };

in
pkgSet.config.hsPkgs
