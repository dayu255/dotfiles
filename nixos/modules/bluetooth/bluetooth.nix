{
  pkgs,
  ...
}:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;

    settings = {
      General = {
        Experimental = true;
      };
      Policy = {
        AutoEnable = "true";
      };
    };
  };
  powerManagement.resumeCommands = ''
    ${pkgs.util-linux}/bin/rfkill unblock bluetooth
  '';

  systemd.services.bluetooth.serviceConfig.ExecStartPre = [
    "${pkgs.util-linux}/bin/rfkill unblock bluetooth"
  ];

  services.blueman.enable = true;
}
