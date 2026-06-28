{
  config,
  pkgs,
  username,
  ...
}:

let
  myWallpaper = pkgs.fetchurl {
    url = "https://github.com/dayu255/assets/blob/main/flower.jpg?raw=true";
    name = "flower.jpg";
    hash = "sha256-2JcFtKoTr5f2XJLGzl0pcybD3LHM7QSQK+87W/ohgCc=";
  };
in
{
  imports = [
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Zram
  zramSwap = {
    enable = true;
    priority = 100;
    algorithm = "lz4";
    memoryPercent = 50;
  };

  networking.hostName = "lollipop"; # Define your hostname.
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
    extraLocaleSettings = {
      LANGUAGE = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF8";
      LC_ADDRESS = "en_US.UTF8";
      LC_IDENTIFICATION = "en_US.UTF8";
      LC_MEASUREMENT = "en_US.UTF8";
      LC_MESSAGES = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF8";
      LC_NAME = "en_US.UTF8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF8";
      LC_TELEPHONE = "en_US.UTF8";
      LC_TIME = "en_US.UTF8";
      LC_COLLATE = "en_US.UTF8";
    };
  };

  # inputMethod
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    # fcitx5.plasma6Support = true;
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
    ];
  };

  # X-window System
  services.xserver.enable = true;
  services.xserver.exportConfiguration = true;

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

  # SSDM(display manager)
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "breeze";
  };

  services.desktopManager.plasma6.enable = true;

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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

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
    ];
    packages = with pkgs; [
      kdePackages.kate
    ];
    shell = pkgs.zsh;
  };

  nix.settings.trusted-users = [
    "root"
    "dayu"
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    google-chrome
    vim
    wget
    file
    ccid
    opensc
    docker
    busybox

    (writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
      			[General]
      			background="${myWallpaper}"
      		'')
  ];

  # Docker deamon enable
  virtualisation.docker.enable = true;

  # nix-ld 動的リンクうまくしてくれるやつ
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      openssl
      ac-library
    ];
  };
  # envfs /bin/bashとかのパスをうまく変換するやつ
  services.envfs.enable = true;

  programs.zsh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
