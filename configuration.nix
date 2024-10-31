{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration_t430s.nix
      <home-manager/nixos>
    ];

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
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = (with pkgs; [
      gnome-photos
      gnome-tour
    ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
    gedit # text editor
    epiphany # web browser
    geary # email reader
    gnome-characters
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
    yelp # Help view
    gnome-contacts
    gnome-initial-setup
  ]);
  programs.dconf.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable sound with pipewire.
  sound.enable = true;
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
    packages = with pkgs; [
      firefox
    ];
  };

  # Enable automatic login for the user.
  security.sudo.wheelNeedsPassword = false;
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "user";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     wget
     emacs
     git
     # gnome.gnome-tweaks
     htop
     btop
  ];
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "user" ];
  };
  programs.mtr.enable = true;
  # services.openssh.enable = true;

  ### ------------------ ###

  home-manager.users.user = { pkgs, lib, ... }: {
    programs.bash.enable = true;

    home.sessionVariables = {
      EDITOR = "emacs";
    };

    # home.packages = [
    #   pkgs.dconf-editor
    # ];

    programs.emacs = {
      enable = true;
      extraPackages = epkgs: [
        epkgs.nix-mode
        epkgs.magit
      ];
    };

    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface".color-scheme = "prefer-dark";
        "org/gnome/desktop/peripherals/keyboard" = {
          numlock-state = true;
          delay = lib.hm.gvariant.mkUint32 170;
          repeat-interval = lib.hm.gvariant.mkUint32 17;
	      };
      };
    };

    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "23.11";
  };

}
