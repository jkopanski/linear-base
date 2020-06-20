{
  pkgs = hackage:
    {
      packages = {
        "binary".revision = (((hackage."binary")."0.8.7.0").revisions).default;
        "ghc-prim".revision = (((hackage."ghc-prim")."0.5.3").revisions).default;
        "rts".revision = (((hackage."rts")."1.0").revisions).default;
        "storable-record".revision = (((hackage."storable-record")."0.0.5").revisions).default;
        "storable-record".flags.splitbase = true;
        "storable-record".flags.buildtests = false;
        "deepseq".revision = (((hackage."deepseq")."1.4.4.0").revisions).default;
        "semigroups".revision = (((hackage."semigroups")."0.19.1").revisions).default;
        "semigroups".flags.bytestring = true;
        "semigroups".flags.unordered-containers = true;
        "semigroups".flags.text = true;
        "semigroups".flags.tagged = true;
        "semigroups".flags.containers = true;
        "semigroups".flags.binary = true;
        "semigroups".flags.hashable = true;
        "semigroups".flags.transformers = true;
        "semigroups".flags.deepseq = true;
        "semigroups".flags.bytestring-builder = false;
        "semigroups".flags.template-haskell = true;
        "template-haskell".revision = (((hackage."template-haskell")."2.15.0.0").revisions).default;
        "vector".revision = (((hackage."vector")."0.12.1.2").revisions).default;
        "vector".flags.unsafechecks = false;
        "vector".flags.internalchecks = false;
        "vector".flags.wall = false;
        "vector".flags.boundschecks = true;
        "primitive".revision = (((hackage."primitive")."0.7.0.1").revisions).default;
        "containers".revision = (((hackage."containers")."0.6.2.1").revisions).default;
        "bytestring".revision = (((hackage."bytestring")."0.10.10.0").revisions).default;
        "storable-tuple".revision = (((hackage."storable-tuple")."0.0.3.3").revisions).default;
        "storable-tuple".flags.splitbase = true;
        "text".revision = (((hackage."text")."1.2.4.0").revisions).default;
        "base".revision = (((hackage."base")."4.13.0.0").revisions).default;
        "transformers".revision = (((hackage."transformers")."0.5.6.2").revisions).default;
        "hashable".revision = (((hackage."hashable")."1.3.0.0").revisions).default;
        "hashable".flags.sse2 = true;
        "hashable".flags.integer-gmp = true;
        "hashable".flags.sse41 = false;
        "hashable".flags.examples = false;
        "pretty".revision = (((hackage."pretty")."1.1.3.6").revisions).default;
        "ghc-boot-th".revision = (((hackage."ghc-boot-th")."8.8.3").revisions).default;
        "base-orphans".revision = (((hackage."base-orphans")."0.8.2").revisions).default;
        "array".revision = (((hackage."array")."0.5.4.0").revisions).default;
        "utility-ht".revision = (((hackage."utility-ht")."0.0.15").revisions).default;
        "integer-gmp".revision = (((hackage."integer-gmp")."1.0.2.0").revisions).default;
        };
      compiler = {
        version = "8.11.20200";
        nix-name = "ghcHEAD";
        packages = {
          "binary" = "0.8.7.0";
          "ghc-prim" = "0.5.3";
          "rts" = "1.0";
          "deepseq" = "1.4.4.0";
          "template-haskell" = "2.15.0.0";
          "containers" = "0.6.2.1";
          "bytestring" = "0.10.10.0";
          "text" = "1.2.4.0";
          "base" = "4.13.0.0";
          "transformers" = "0.5.6.2";
          "pretty" = "1.1.3.6";
          "ghc-boot-th" = "8.8.3";
          "array" = "0.5.4.0";
          "integer-gmp" = "1.0.2.0";
          };
        };
      };
  extras = hackage:
    { packages = { linear-base = ./.plan.nix/linear-base.nix; }; };
  modules = [
    ({ lib, ... }:
      { packages = { "linear-base" = { flags = {}; }; }; })
    ];
  }