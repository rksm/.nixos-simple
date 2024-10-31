{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration_t430s.nix ];

  nix.settings.experimental-features = [ "flakes" "nix-command" ];
  system.stateVersion = "23.11";

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.networkmanager.enable = true;
  networking.hostName = "t430s"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = (with pkgs; [ gnome-photos gnome-tour ])
    ++ (with pkgs; [
      cheese
      epiphany
      geary
      yelp
      gnome-music
      gnome-characters
      tali
      iagno
      hitori
      atomix
      gnome-contacts
      gnome-initial-setup
    ]);
  programs.dconf.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    variant = "";
    layout = "us";
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.user = {
    isNormalUser = true;
    description = "user";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ firefox ];
  };

  # Enable automatic login for the user.
  security.sudo.wheelNeedsPassword = false;
  services.displayManager.autoLogin = {
    enable = true;
    user = "user";
  };

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    wget
    curl
    emacs
    git
    git-lfs
    git-filter-repo
    htop
    btop
    iotop
    iftop
    nmap
    killall
    xclip # for xclip -selection clipboard

    # low priority so that we can to use trace from elsewhere
    (pkgs.lowPrio config.boot.kernelPackages.perf)
    config.boot.kernelPackages.tmon # thermal monitoring
    config.boot.kernelPackages.cpupower

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    ripgrep
    fd

    google-chrome

    nixfmt
  ];
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "user" ];
  };
  programs.mtr.enable = true;
  # services.openssh.enable = true;
}
