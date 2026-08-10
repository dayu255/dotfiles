{
  pkgs,
}:
pkgs.writeShellApplication {
  name = "nix-template";
  runtimeInputs = [ pkgs.coreutils ];
  text = ''
    FLAKE_NIX_TEMPLATE="${./flake-template.nix}"
    ${builtins.readFile ./nix-template.sh}
  '';
}
