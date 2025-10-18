# Neon Laptop Configuration
# Mobile workstation with KDE Plasma

{ config, pkgs, lib, ... }:

{
  imports = [ ];

  # Temporarily permit insecure packages for initial installation
  nixpkgs.config.permittedInsecurePackages = [
    "electron-27.3.11"  # Used by Discord/Obsidian, will be fixed post-install
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Hostname
  networking.hostName = "neon-laptop";

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable NetworkManager
  networking.networkmanager.enable = true;

  # Enable SSH server
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "no"; # Ensure root login is disabled after install
  services.openssh.settings.PasswordAuthentication = false; # Enforce key-based auth

  # Firewall
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ]; # Allow SSH

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file systems, start to apply.
  #
  # Each release makes subtle changes to the way things are configured,
  # so a change here may affect how your system behaves, even if you
  # don't change anything else. For more details see the NixOS
  # release notes for a particular release.
  system.stateVersion = "24.05"; # Did you read the comment?

  # Enable the homelab modules
  homelab.shell.aliases.enable = true;
  homelab.shell.oh-my-zsh-enhanced.enable = true;

  # Desktop environment
  homelab.desktop.kde-plasma.enable = true;
  homelab.desktop.hyprland.enable = false; # Disable by default, but available
  homelab.desktop.gnome.enable = false;    # Disable by default, but available

  # Applications
  homelab.apps.development.enable = true;
  homelab.apps.browsers.enable = true;
  homelab.apps.media.enable = true;
  homelab.apps.productivity.enable = true;
  homelab.apps.torrents.enable = false;  # Disabled temporarily due to qbittorrent security issue

  # Hardware
  homelab.hardware.laptop.enable = true;
  homelab.hardware.gpu-intel.enable = true;
}

