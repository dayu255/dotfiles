{ ... }:
{
  programs.codexDesktopLinux = {
    enable = true;
    linuxFeatures = [
      "ui-tweaks"
    ];
  };
}
