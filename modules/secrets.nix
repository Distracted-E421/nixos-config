# Secrets Management with sops-nix
# Provides encrypted secrets accessible to NixOS configuration

{ config, pkgs, lib, ... }:

{
  # sops-nix configuration
  sops = {
    # Default secrets file location
    defaultSopsFile = ../secrets/secrets.yaml;
    
    # Validate secrets at build time
    validateSopsFiles = false;  # Set to true once you have encrypted secrets
    
    # Age key configuration
    # This file contains the private key for decrypting secrets
    # DO NOT commit this file! It's in .gitignore
    age = {
      # Default key file location for all machines
      # Each machine will need its own key generated
      keyFile = "/var/lib/sops-nix/key.txt";
      
      # Automatically generate key if it doesn't exist (optional)
      # Set to false for production
      generateKey = true;
    };
    
    # Example secrets (uncomment and modify as needed)
    # secrets = {
    #   # User password hash
    #   "users/e421/password" = {
    #     neededForUsers = true;  # Available before user creation
    #   };
    #   
    #   # WiFi password
    #   "wifi/home/password" = {};
    #   
    #   # Tailscale auth key
    #   "tailscale/auth-key" = {};
    #   
    #   # GitHub token
    #   "github/token" = {
    #     owner = "e421";
    #     group = "users";
    #     mode = "0400";  # Read-only for owner
    #   };
    # };
  };
  
  # Install sops for manual secret management
  environment.systemPackages = with pkgs; [
    sops
    age  # Encryption tool
  ];
}
