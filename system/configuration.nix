# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ pkgs, ... }:

{
  imports =
    [ ./hardware-configuration.nix ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev";

  services.fwupd.enable = true;

#  boot.kernelParams = [
#    amdgpu.sg_display=0;
#  ];

  networking.hostName = "babelfish"; # Define your hostname.

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  time.timeZone = "Australia/Sydney";
  i18n.defaultLocale = "en_US.UTF-8";

  console.useXkbConfig = true; # use xkb.options in tty.

  nixpkgs.overlays = [
      (final: prev: { 
        river = prev.river.overrideAttrs (old: { 
          src = prev.fetchFromGitea {
            domain = "codeberg.org";
            owner = "river";
            repo = "river";
            rev = "5262a4c5a61f547acd29560f1af9cf342b9958ae";
            fetchSubmodules = true;
            hash = "sha256-BeVtwvmgJLhecavmeZSWWkBQ4sy+vgS9z6+sJgvFNaI=";
          }; 
        }); 
#         python312 = (prev.python312.overrideAttrs (old: {
#           src = prev.fetchFromGitHub {
#             owner = "Scibuild";
#             repo = "cpython";
#             fetchSubmodules = true;
#             rev = "refs/heads/v312";
#             hash = "sha256-acPtGr3+ZU69P8AZJAUzc88RYoASSFEKA0iO/3bUwMo=";
#           };
#         })).override { 
#           packageOverrides = py_final: py_prev: {
#             capstone = py_prev.capstone.overrideAttrs (old: { 
#               disabled = false; 
#               # format = "wheel";
#               patches = [ ../patches/python312.capstone.patch ];
#               nativeBuildInputs = [ py_prev.setuptools ];
#             });
#             unicorn = py_prev.unicorn.overrideAttrs (old: { 
#               format = "wheel";
#               nativeBuildInputs = [ py_prev.setuptools ];
#             });
#          };
#        };
        python310 = (prev.python310.overrideAttrs (old: {
          src = prev.fetchFromGitHub {
            owner = "Scibuild";
            repo = "cpython";
            rev = "refs/heads/v310";
            hash = "sha256-ARxxpfvFrv7wopzFMD2B0leUXTVosWWZdAa2ARzD1ww=";
          };
        })).override {
          packageOverrides = py_final: py_prev: {
            pip = py_prev.pip.overrideAttrs (old: { nativeBuildInputs = old.nativeBuildInputs ++ [ py_prev.tomli ]; });
            furo = py_prev.furo.overrideAttrs (old: { nativeBuildInputs = old.nativeBuildInputs ++ [ py_prev.tomli ]; });
          };
        };
      }) 
  ];

  programs.river.enable = true;
  programs.sway.enable = true;

  xdg.portal.wlr.enable = true;
  xdg.portal.enable = true;
  xdg.portal.wlr.settings = {
    preferred = {
      "org.freedesktop.impl.portal.ScreenCast"="wlr";
      "org.freedesktop.impl.portal.Screenshot"="wlr";
    };
  };

  # Configure keymap in X11
  services.xserver.xkb.options = "caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
  };

  services.libinput.enable = true;

  users.users.alex = {
    isNormalUser = true;
    extraGroups = [ "wireshark" "wheel" "vboxusers" "dialout" "libvirtd" ];
    packages = with pkgs; [ maestral ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;

# Not working
  systemd.user.services.maestral-start = {
    enable = true;
    description = "Start maestral on startup";
    serviceConfig.ExecStart = "maestral start";
    serviceConfig.Type = "simple";
    wantedBy = [ "default.target" ];
  };


  services.globalprotect.enable = true;

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim
    neovim
    wget
    zsh
    
    wl-clipboard

    pavucontrol
    pamixer

    xdg-desktop-portal-wlr

    wireshark
    sshfs
    globalprotect-openconnect
    # kdePackages.polkit-kde-agent-1
    polkit_gnome
    networkmanagerapplet

    usbutils
    udiskie
    udisks

    zip
    unzip

    qemu

    (python310.withPackages (p: [ p.pwntools p.z3-solver p.python-lsp-server p.pylsp-mypy p.weasyprint p.virtualenv p.pyaml p.pycrypto p.gmpy2 ]))
    pango
    # python311Packages.pwntools
  ];
  environment.pathsToLink = [ "/share/zsh" ];

  services.gvfs.enable = true;
  services.udisks2.enable = true;

  programs.neovim = {
    enable = true;
    vimAlias = true;
    defaultEditor = true;
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk
    liberation_ttf
    fira-code
    fira-code-symbols
    font-awesome
    libertine
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowedUDPPorts = [ ];

  programs.wireshark.enable = true;

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "alex" ];
  # virtualisation.virtualbox.host.enableKvm = true;
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  services.fprintd.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  programs.steam.enable = true;
  services.joycond.enable = true;
  
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    libGL
    mesa
    vulkan-loader
    zlib
    glib
    alsa-lib
    libpulseaudio
    # libvorbis
    # libpng
    # libGLU
    # nspr
    # SDL
    # libcxx
    # espeak-classic
    # gnustep.base
    # gnustep.libobjc
    # openal
    # nss
    # at-spi2-atk
    # cups
    # dbus
    # gtk3
    # pango
    # cairo
    # libdrm
    # expat
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libxcb
    xorg.libxkbfile
    xorg.libxshmfence
    libxkbcommon
  ];

  # powerManagement.cpuFreqGovernor = "ondemand";

  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  system.stateVersion = "23.11"; # Don't change

}

