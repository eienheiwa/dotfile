# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
       /home/kakoi/musnix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "lambda";
  networking.networkmanager.enable = true;
  time.timeZone = "Asia/Tokyo";
  networking.useDHCP = false;
  networking.interfaces.enp0s26u1u2.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  # Select internationalisation properties.
   i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      keyMap = "jp106";
    };

   i18n.inputMethod = {
     enabled = "fcitx";
     fcitx.engines = with pkgs.fcitx-engines; [ mozc ];
     };

  # Enable the Plasma 5 Desktop Environment.
    services.xserver.enable = true;
    services.xserver.displayManager.lightdm.enable = true;
    services.xserver.desktopManager.plasma5.enable = false;
    services.xserver.windowManager.xmonad.enable = true;
    services.xserver.windowManager.xmonad.enableContribAndExtras = true;
    services.xserver.layout = "jp";
    services.xserver.xkbOptions = "ctrl:nocaps";
    services.printing.enable = true;
    services.xserver.libinput.enable = true;
    services.openssh.enable = true;

# Enable sound.
   sound.enable = true;
   hardware.pulseaudio.enable = true;
   hardware.pulseaudio.support32Bit = true;
   hardware.pulseaudio.package = pkgs.pulseaudio.override { jackaudioSupport = true; };
   services.jack.jackd.enable = true;
   services.jack.alsa.enable = false;
   services.jack.loopback.enable = true;
# realtime audio.
   musnix.enable = true;
   musnix.alsaSeq.enable = true;
   musnix.kernel.optimize = true; 
   musnix.kernel.realtime = true;
   musnix.kernel.packages = pkgs.linuxPackages_latest_rt;
   musnix.kernel.latencytop = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.kakoi = {
      shell = pkgs.fish;
      isNormalUser = true;
      extraGroups = [ "wheel" "audio" "jackaudio" ]; # Enable ‘sudo’ for the user.
    };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
    environment.systemPackages = with pkgs; [
      wget git unzip scrot xclip feh neofetch
      firefox spotify discord dropbox
      jack2 libjack2 qjackctl pavucontrol
      puredata supercollider musescore bitwig-studio reaper
      xmobar dmenu alacritty emacs neovim fish
    ];
	nixpkgs.config.allowUnfree = true;

services.picom = {
  enable = true;
  fade = true;
  inactiveOpacity = 0.9;
  shadow = true;
  fadeDelta = 4;
};

  # fontconfig

   fonts = {
    fonts = with pkgs; [
     cherry
     ipafont
     powerline-fonts
  ];

   fontconfig = {
    defaultFonts = {
     monospace = [
      "DejaVu Sans Mono For Powerline"
      "IPAGothic"
  ];
  
   serif = [
  "DejaVu Serif"
  "IPAMincho"
  ];
   
   sansSerif = [
    "DejaVu Sans"
    "IPAGothic"
    ];
   };
  };
 };




  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

