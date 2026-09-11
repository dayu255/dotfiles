{
  pkgs,
  ...
}:
let
  fira-code-i-script = pkgs.stdenvNoCC.mkDerivation {
    pname = "fira-code-i-script";
    version = "1.0.0";

    src = pkgs.fetchFromGitHub {
      owner = "kencrocken";
      repo = "FiraCodeiScript";
      rev = "f87318c072f1d9c7d075b1f702c3e4dd4df76a15";
      hash = "sha256-tl3VmqagiQSlkYeNWOt+rTRHHuSBEGiIh/+KpRj1h3g=";
    };

    installPhase = ''
      runHook preInstall
      install -d -m 755 $out/share/fonts/truetype
      install -m 644 *.ttf $out/share/fonts/truetype/
      runHook postInstall
    '';
  };
in
{
  fonts = {
    packages = (
      with pkgs;
      [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
        terminus_font
        cantarell-fonts
        nerd-fonts.fira-code
        jetbrains-mono
        hackgen-nf-font

        fira-code-i-script
      ]
    );
    fontDir.enable = true;
    fontconfig = {
      defaultFonts = {
        serif = [
          "Noto Serif CJK JP"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "Noto Sans CJK JP"
          "Noto Color Emoji"
        ];
        monospace = [
          "HackGen35 Console NF"
          "Noto Color Emoji"
        ];
        emoji = [
          "Noto Color Emoji"
        ];
      };
    };
  };
}
