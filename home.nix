{username, homeDirectory}: { pkgs, ... }: 
let
  packages = with pkgs; [
    firefox
    killall
    ripgrep
    ripgrep-all
    ncdu
    htop
    neofetch
    qjackctl
    zoom-us
    discord
#     dropbox-cli
#     dropbox
    maestral

    brightnessctl
    grim
    slurp

    typst
    libreoffice-qt

    qalculate-qt
  ];
in
{
  programs.home-manager.enable = true;

  home = {
    inherit username homeDirectory packages;
    stateVersion = "24.05";
    file.".Xcompose".source = ./config/xcompose/.XCompose;
    file.".config/nvim".source = ./config/nvim;

    sessionVariables = {
      MANPAGER = "nvim +Man!";
      MANWIDTH = "72";
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };


  wayland.windowManager.river = 
  with builtins; let
    bitshift = x: y: 
      assert builtins.isInt x;
      assert builtins.isInt y;
      if y == 0 then
         x
      else if y > 0 then
         bitshift (x * 2) (y - 1)
      else
         bitshift (x / 2) (y + 1);

    mkTagKeys = i:{
      "Super ${toString (i + 1)}" = "set-focused-tags ${toString (bitshift 1 i)}";
      "Super+Shift ${toString (i + 1)}" = "set-view-tags ${toString (bitshift 1 i)}";
    };
    tagKeys = foldl' (acc: x: acc // x) {} 
      (genList (x: mkTagKeys (x - 1)) 10);
    
  in {
    enable = true;
    settings = {
      border-width = 2;
      declare-mode = [ "normal" ];
      map = {
        "-repeat".normal = {
          "None XF86AudioRaiseVolume"  = "spawn 'pamixer -i 5'";
          "None XF86AudioLowerVolume"  = "spawn 'pamixer -d 5'";

          "None XF86MonBrightnessUp"   = "spawn 'brightnessctl set +5%'";
          "None XF86MonBrightnessDown" = "spawn 'brightnessctl set 5%-'";
        };
        normal = {
          "Super Q" = "close";
          "Super+Shift E" = "exit";
          "Super Return" = "spawn foot";
          "Super F" = "toggle-fullscreen";

          "Super K" = "focus-view up";
          "Super J" = "focus-view down";
          "Super H" = "focus-view left";
          "Super L" = "focus-view right";
          "Super+Shift J" = "swap next";
          "Super+Shift K" = "swap previous";

          "Super Space" = "spawn 'rofi -show drun'";

          "Super+Shift Y" = 
            "spawn 'sh -c '\"'\"'grim -g \"$(slurp)\" - | wl-copy -t image/png'\"'\"";

          "None XF86AudioMute"         = "spawn 'pamixer --toggle-mute'";
        } // tagKeys;
      };
      map-pointer = { 
        normal = {
          "Super BTN_LEFT" = "move-view";
          "Super BTN_RIGHT" = "resize-view";
          "Super BTN_MIDDLE" = "toggle-float";
        };
      };
      keyboard-layout = "-options caps:escape,compose:ralt us";
      set-repeat = "50 300";
      default-layout = "rivertile";
      hide-cursor.when-typing = true;
      input = {
        "pointer-2362-628-PIXA3854:00_093A:0274_Touchpad" = {
          click-method = "clickfinger";
          tap = false;
          pointer-accel = 0.8;
          events = true;
          accel-profile = "flat";
          natural-scroll = true;
          scroll-factor = 0.3;
          tap-button-map = "left-right-middle";
          scroll-method = "two-finger";
        };
      };
    };
    extraConfig = ''
      rivertile -view-padding 6 -outer-padding 6 &
      waybar &
    '';
  };

  programs.git = {
    enable = true;
    userEmail = "tmbx100@gmail.com";
    userName = "Alex Mirrlees-Black";
    aliases = {
      c = "commit";
      a = "add";
      s = "status";
      l = "log --oneline --graph --all";
    };
    extraConfig = {
      init.defaultBranch = "main";
      commit.verbose = true;
      status.short = true;
      status.branch = true;
      fetch.prune = true;
      pull.rebase = true;
    };
  };

  programs.nushell = {
    enable = true;
    configFile.source = ./config/nushell/config.nu;
    envFile.source = ./config/nushell/env.nu;
  };

  programs.kitty = {
    enable = true;
  };

  programs.waybar = {
    enable = true;
  };


# Probably will change
  programs.rofi = {
    enable = true;
  };
}
