{
  pkgs,
}:
pkgs.writeShellApplication {
  name = "nix-template";
  runtimeInputs = [ pkgs.coreutils ];
  text = ''
    FLAKE_NIX_TEMPLATE="${./flake.nix.template}"
    ${builtins.readFile ./nix-template.sh}
  '';
}
