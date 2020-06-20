{ sources ? import ./nix/sources.nix }:

let
  haskellNix = import sources."haskell.nix" {};
  nixpkgs = import sources.nixpkgs haskellNix.nixpkgsArgs;
  haskell = nixpkgs.haskell-nix;

in haskell.project {
  projectFileName = "linear-base.cabal";
  src = haskell.haskellLib.cleanGit {
    name = "linear-base";
    src = ./.;
  };
  compiler-nix-name = "ghcHEAD";
}
