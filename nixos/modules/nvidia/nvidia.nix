{
  pkgs,
  config,
  ...
}:
{
  # Nvidia
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [
    "nvidia"
  ];
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    nvidiaSettings = true;
    open = true;

    modesetting.enable = true;

    powerManagement.enable = true;
    powerManagement.finegrained = true;

    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;

      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:2@0:0:0";
    };
  };
}
