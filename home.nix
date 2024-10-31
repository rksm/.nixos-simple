{ config, pkgs, lib, ... }:

{
  home.username = "user";
  home.homeDirectory = "/home/user";
  home.stateVersion = "23.11";

  programs.bash.enable = true;

  home.sessionVariables = { EDITOR = "emacs"; };

  programs.emacs = {
    enable = true;
    extraPackages = epkgs:
      with epkgs; [
        use-package
        dash
        dash-functional
        s
        nix-mode
        magit
        adaptive-wrap
        async-backup
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

  home.file.".emacs.d/init.el".source =
    config.lib.file.mkOutOfStoreSymlink /etc/nixos/.emacs.d/init.el;
}
