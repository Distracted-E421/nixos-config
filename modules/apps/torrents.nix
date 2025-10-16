# Torrents Module
# qBittorrent, Transmission

{ config, pkgs, pkgs-unstable, lib, ... }:

{
  options = {
    homelab.apps.torrents.enable = lib.mkEnableOption "torrent clients";
  };

  config = lib.mkIf config.homelab.apps.torrents.enable {
    environment.systemPackages = with pkgs; [
      # Torrent clients
      qbittorrent                    # Feature-rich torrent client
      transmission_4-gtk             # Lightweight torrent client
      
      # Alternative clients
      deluge-gtk                     # Plugin-based torrent client
      
      # Utilities
      tremc                          # Terminal transmission client
    ];
    
    # Optional: Run transmission daemon (disabled by default)
    # services.transmission = {
    #   enable = false;
    #   settings = {
    #     download-dir = "/home/e421/Downloads/torrents";
    #     incomplete-dir-enabled = true;
    #     rpc-bind-address = "0.0.0.0";
    #     rpc-whitelist = "127.0.0.1,192.168.*.*";
    #   };
    # };
    
    # Firewall rules for torrent clients (if needed)
    # networking.firewall.allowedTCPPortRanges = [
    #   { from = 6881; to = 6889; }
    # ];
    # networking.firewall.allowedUDPPortRanges = [
    #   { from = 6881; to = 6889; }
    # ];
  };
}
