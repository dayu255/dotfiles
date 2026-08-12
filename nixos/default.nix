{
  config,
  pkgs,
  username,
  ...
}:
{
  imports = [
    # Input
    ./modules/input/input.nix
    # Font
    ./modules/font/font.nix
    # Dynamic Link
    ./modules/nix-ld/nix-ld.nix
    # Virtual FS
    ./modules/envfs/envfs.nix
  ];

  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [
      "wheel"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable networking
  #networking.networkmanager.enable = true;

  # Enables wireless support via wpa_supplicant.
  #networking.wireless.enable = true;

  # TimeZone
  time.timeZone = "Asia/Tokyo";
  time.hardwareClockInLocalTime = false;

  # Language
  i18n = {
    defaultLocale = "ja_JP.UTF-8";
    supportedLocales = [
      "ja_JP.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];
    #extraLocaleSettings = {
    #  LANGUAGE = "en_US.UTF-8";
    #  LC_ALL = "en_US.UTF-8";
    #  LC_CTYPE = "en_US.UTF-8";
    #  LC_ADDRESS = "en_US.UTF-8";
    #  LC_IDENTIFICATION = "en_US.UTF-8";
    #  LC_MEASUREMENT = "en_US.UTF-8";
    #  LC_MESSAGES = "en_US.UTF-8";
    #  LC_MONETARY = "en_US.UTF-8";
    #  LC_NAME = "en_US.UTF-8";
    #  LC_NUMERIC = "en_US.UTF-8";
    #  LC_PAPER = "en_US.UTF-8";
    #  LC_TELEPHONE = "en_US.UTF-8";
    #  LC_TIME = "en_US.UTF-8";
    #  LC_COLLATE = "en_US.UTF-8";
    #};
  };

  # Nix
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.auto-optimise-store = true;

  environment.systemPackages = with pkgs; [
    vim
    curl
    wget
    file
    coreutils

    # NetWork
    inetutils
    dig

    # Hardware, System
    pciutils
    usbutils
    lm_sensors
    htop

    # Storage, FS
    parted
    smartmontools
    dosfstools
    e2fsprogs
  ];

  # ssh-agent
  programs.ssh.startAgent = true;
}
