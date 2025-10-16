# Laptop Hardware Module
# Power management, battery, touchpad, etc.

{ config, pkgs, lib, ... }:

{
  options = {
    homelab.hardware.laptop.enable = lib.mkEnableOption "laptop-specific features";
  };

  config = lib.mkIf config.homelab.hardware.laptop.enable {
    # Touchpad support with libinput
    services.libinput = {
      enable = true;
      touchpad = {
        tapping = true;
        naturalScrolling = true;
        accelProfile = "adaptive";
        clickMethod = "clickfinger";
        disableWhileTyping = true;
        middleEmulation = true;
      };
    };
    
    # Power management
    services.power-profiles-daemon.enable = false;  # Conflicts with TLP
    services.tlp = {
      enable = true;
      settings = {
        # CPU performance
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
        
        # Turbo boost
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        
        # Battery care (stop charging at 80%)
        START_CHARGE_THRESH_BAT0 = 40;
        STOP_CHARGE_THRESH_BAT0 = 80;
        
        # USB autosuspend
        USB_AUTOSUSPEND = 1;
        
        # WiFi power save
        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "on";
      };
    };
    
    # Laptop mode for better power management
    powerManagement = {
      enable = true;
      powertop.enable = true;
    };
    
    # Thermald for Intel CPUs
    services.thermald.enable = true;
    
    # Automatic CPU frequency scaling
    services.auto-cpufreq = {
      enable = true;
      settings = {
        charger = {
          governor = "performance";
          turbo = "auto";
        };
        battery = {
          governor = "powersave";
          turbo = "auto";
        };
      };
    };
    
    # Enable touchpad support
    services.xserver.libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        tapping = true;
        middleEmulation = true;
        disableWhileTyping = true;
      };
    };
    
    # Backlight control
    programs.light.enable = true;
    
    # Battery and power monitoring
    environment.systemPackages = with pkgs; [
      acpi
      powertop
      brightnessctl
      light
      
      # Battery monitoring
      upower
      
      # TLP UI
      tlpui
    ];
    
    # Add user to video group for backlight control
    users.users.e421.extraGroups = [ "video" ];
    
    # Suspend on lid close
    services.logind = {
      lidSwitch = "suspend";
      lidSwitchExternalPower = "lock";
      extraConfig = ''
        HandlePowerKey=suspend
        IdleAction=suspend
        IdleActionSec=30min
      '';
    };
  };
}
