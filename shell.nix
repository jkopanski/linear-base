let
  hsPkgs = import ./default.nix {};
in
  hsPkgs.linear-base.components.all
