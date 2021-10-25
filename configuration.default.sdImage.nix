{ config, pkgs, lib, ... }:
{

  imports = [
    # <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64.nix>
    <nixpkgs/nixos/modules/installer/sd-card/sd-image-aarch64-installer.nix>

    # For nixpkgs cache
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  sdImage.compressImage = false;
  
  # NixOS wants to enable GRUB by default
  boot.loader.grub.enable = false;

  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;  

  boot.kernelParams = ["cma=256M"];
  boot.loader.raspberryPi.uboot.enable = true;
  boot.loader.raspberryPi = {
    enable = true;
    version = 3;
  };
  # boot.loader.raspberryPi.firmwareConfig = ''
    # gpu_mem=256
  # '';
  
  # !!! Set to specific linux kernel version
  boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.kernelPackages = pkgs.linuxPackages_5_4;
  #boot.kernelPackages = pkgs.linuxPackages_rpi3;

  # Settings above are the bare minimum
  # All settings below are customized depending on your needs

  # systemPackages
  environment.systemPackages = with pkgs; [ 
    curl wget nano ];

  services = {
      openssh = {
          enable = true;
          permitRootLogin = "yes";
      };
      adguardhome = {
          enable = true;
      };
      unbound = {
          enable = true;
      };
      dnsmasq = {
          enable = false;
      };
  };
 
  programs.zsh = {
      enable = true;
  };
  
  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr";
  };

  time.timeZone = "Europe/Paris";

  networking = {
      firewall.enable = false;
      hostName = "nixpi";
      interfaces.eth0 = {
      useDHCP = true;
    };
  };
  
  # WiFi
  # hardware = {
    # enableRedistributableFirmware = true;
    # #firmware = [ pkgs.wireless-regdb ];
  # };
  
  hardware.enableRedistributableFirmware = true;
  networking.wireless.enable = true;
  
  # Preserve space by disabling documentation and enaudo ling
  # automatic garbage collection
  documentation.nixos.enable = false;
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 30d";
  boot.cleanTmpDir = true;

  nix.trustedUsers = [ "nixos" ];

  # put your own configuration here, for example ssh keys:
  users.defaultUserShell = pkgs.zsh;
  users.mutableUsers = false;
  users.groups = {
    nixos = {
      gid = 1000;
      name = "nixos";
    };
  };
  users.users = {
    nixos = {
      uid = 1000;
      isNormalUser = true;
      home = "/home/nixos";
      name = "nixos";
      group = "nixos";
      shell = pkgs.zsh;
      extraGroups = [ "wheel" ];
      #hashedPassword = "4369C0B1067755C9EC057024EC1BE4ECB27955683A4BEEBD638DBF6CB026D73D1224B18A9370177D3FB164F9A054CB7A70DD0BF7E053BC91FA167D55503B3CC6";
    };
  };
  users.extraUsers.root.openssh.authorizedKeys.keys = [
      # Your ssh key
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCvwTiBiZsTh9NyU+JVDgRF7TWfoyVWUVB+wwvdY54FkL797ckdxUQBLCiBwJfxbO3u00hOz5Ibrw80WJVpGV0D5Flf7CKapB1r0/j4Jh2w6nRtOEnt25XnbHiL+F7RYTBfR0awZ9nMLuJecJ7XSYaU688fYZlKkRbshp4qViif/J5bj/7nG9ySfJWgFsNEz6J2x2yBaeeZYTRXt/PJsDW8Rpsdud8U3Ob+jodfunJlxMWELN4KpE9sL8buDy3kVgUGuC2jr8R4RoKH7EKrFDrHhwzYozGsYzmYnWmYIeatOKIy3ueCjtR7MlmulUAqWVnSBtcT+pf9FVlMqtiWqx4Ls/XvuABKoXDBr7M2nU16aMGB0RW1eSUDkmv/VZUpDUQX9MRw2yBkPPMGay8/ozJxskqCYvkqPvloGlyUNrB+R0Whc/QJBBUkHH8kOC69TwwY2pzLi2SltrIK2JA+E4LLNpSFrFjApcxHqm3pdS1tnqLnrVzO60tUqe/FAJ+jfPc= root@Cobblepot"
  ];
}
