{
  pkgs,
  ...
}:

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
