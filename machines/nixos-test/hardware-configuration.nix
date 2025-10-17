# VM Hardware Configuration - nixos-test
# This is a minimal hardware config for VM testing

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  # Boot loader - simple GRUB for VM
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";  # VM virtual disk

  # Kernel modules for VM
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # Root filesystem - FIXED to use actual UUID
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/ae2accb1-79bc-4cb7-aa1b-7e0816182857";
    fsType = "ext4";
  };

  # Swap (optional for VM)
  swapDevices = [ ];

  # Networking
  networking.useDHCP = lib.mkDefault true;

  # Hardware settings
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
