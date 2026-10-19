{
  ...
}:
{
  services.desktopManager.plasma6.enable = true;

  # Hyprland終了後にDrKonqiが画面へ接続できず、自己再帰でクラッシュするのを防ぐ。
  # Plasmaが起動中の場合だけGUIを許可し、systemd-coredumpによる記録は維持する。
  systemd.user.services."drkonqi-coredump-launcher@" = {
    overrideStrategy = "asDropin";
    unitConfig.Requisite = [ "plasma-workspace.target" ];
    after = [ "plasma-workspace.target" ];
  };
}
