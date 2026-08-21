{
  pkgs,
  username,
  ...
}:
{
  networking.hostName = "shiratama"; # Define your hostname.

  imports = [
    # Input
    ./modules/input/input.nix
    # Font
    ./modules/font/font.nix
    # Desktop
    ../../nixos/modules/hyprland/hyprland.nix
    ../../nixos/modules/plasma/plasma.nix
    ../../nixos/modules/sddm/sddm.nix
    # Nvidia
    ../../nixos/modules/nvidia/nvidia.nix
  ];

  # Use latest linux kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Zram
  zramSwap = {
    enable = true;
    algorithm = "lz4";
    memoryPercent = 50;
    priority = 100;
  };

  # Enable networking
  networking.networkmanager.enable = true;

  # Enables wireless support via wpa_supplicant.
  #networking.wireless.enable = true;

  # X-window System
  services.xserver.enable = true;
  services.xserver.exportConfiguration = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "jp";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;

    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Suspend when close lid
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "video"
    ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    ccid
    opensc
    docker

    # SDDMの壁紙の設定
    (writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
      [General]
      background="${../../assets/flower.png}"
    '')
  ];

  # Docker deamon enable
  virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
