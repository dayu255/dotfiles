{
  config,
  pkgs,
  username,
  ...
}:
{
  services.tailscale = {
    enable = true;
    extraSetFlags = [
      "--operator=${username}"
    ];
  };

  environment.systemPackages = with pkgs; [
    tailscale
  ];

  # ファイアウォール（UDP 41641ポートの許可）
  networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];

  #services.resolved.enable = true;
}
