default:
    just --list

switch:
    sudo nixos-rebuild --flake .#default switch
