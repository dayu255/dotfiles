{
  ...
}:
{
  # 起動時の問題とZedのstatxでのFUSE応答待ちを切り分けるため無効化。
  # nix-ldは有効のまま維持する。両者の競合が原因かは未確定。
  # /bin/bashなどを前提にする外部スクリプトは別途対応が必要。
  services.envfs.enable = false;
}
