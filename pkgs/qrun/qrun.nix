{
  pkgs
}:
pkgs.writeShellApplication {
  name = "qrun";
  text = ''
    export CPLUS_INCLUDE_PATH="${pkgs.ac-library}/include"
    ${builtins.readFile ./qrun.sh}
  '';
}
