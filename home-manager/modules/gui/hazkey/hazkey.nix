{
  pkgs,
  inputs,
  ...
}:
let
  inherit (pkgs.stdenv) system;
in
{
  imports = [ inputs.nix-hazkey.homeModules.hazkey ];

  services.hazkey = {
    enable = true;
    zenzai.package = inputs.nix-hazkey.packages.${system}.zenzai_v3_2-small;
  };
}
