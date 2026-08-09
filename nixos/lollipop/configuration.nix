{
  config,
  pkgs,
  username,
  ...
}:
{
  networking.hostName = "lollipop"; # Define your hostname.

  imports = [
    ../modules/hyprland/hyprland.nix
    ../modules/plasma/plasma.nix
    ../modules/input/input.nix
    ../modules/sddm/sddm.nix
    ../modules/nvidia/nvidia.nix
    ../modules/font/font.nix
    ../modules/nix-ld/nix-ld.nix
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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
    # extraLocaleSettings = {
    #   LANGUAGE = "en_US.UTF-8";
    #   LC_ALL = "en_US.UTF-8";
    #   LC_CTYPE = "en_US.UTF-8";
    #   LC_ADDRESS = "en_US.UTF-8";
    #   LC_IDENTIFICATION = "en_US.UTF-8";
    #   LC_MEASUREMENT = "en_US.UTF-8";
    #   LC_MESSAGES = "en_US.UTF-8";
    #   LC_MONETARY = "en_US.UTF-8";
    #   LC_NAME = "en_US.UTF-8";
    #   LC_NUMERIC = "en_US.UTF-8";
    #   LC_PAPER = "en_US.UTF-8";
    #   LC_TELEPHONE = "en_US.UTF-8";
    #   LC_TIME = "en_US.UTF-8";
    #   LC_COLLATE = "en_US.UTF-8";
    # };
  };

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

  # Nix
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.auto-optimise-store = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "video"
    ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;

  nix.settings.trusted-users = [
    "root"
    "${username}"
  ];

  environment.systemPackages = with pkgs; [
    google-chrome
    vim
    wget
    file
    ccid
    opensc
    docker
    coreutils
    net-tools

    (writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
      [General]
      background="${../../assets/flower.png}"
    '')
  ];

  # ssh-agent
  programs.ssh.startAgent = true;

  # Docker deamon enable
  virtualisation.docker.enable = true;

  # envfs /bin/bashとかのパスをうまく変換するやつ
  services.envfs.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
