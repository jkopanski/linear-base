{ sources ? import ./nix/sources.nix }:

let
  haskellNix = import sources."haskell.nix" {};
  nixpkgs = import sources.nixpkgs haskellNix.nixpkgsArgs;
  haskell = nixpkgs.haskell-nix;

  pkgSet = haskell.mkCabalProjectPkgSet {
    plan-pkgs = import ./pkgs.nix;
    pkg-def-extras = [];
    modules = [];
  };

in
pkgSet.config.hsPkgs
