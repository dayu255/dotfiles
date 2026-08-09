{
  pkgs,
  ...
}:
{
  # 動的リンクをうまくしてくれるやつ
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      openssl
      ac-library
    ];
  };
}
