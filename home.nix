{username, homeDirectory}: { pkgs, lib, config, ... }: 
let
  packages = with pkgs; [
    # firefox ungoogled-chromium
    killall
    ripgrep
    ripgrep-all
    ncdu
    htop
    neofetch
    qjackctl
    zoom-us
    maestral
    obs-studio

    autotiling-rs

    brightnessctl
    grim
    slurp
    sway-contrib.grimshot
    swaynotificationcenter

    typst
    typstyle
    libreoffice-qt
    # blender
    imagemagick
    # aseprite
    puredata

    qalculate-qt

    poppler_utils
    zathura
    evince

    ranger

    rofi-wayland

    # tool for graphical popups in shell scripts
    yad
    jq

    # for managing displays
    wdisplays

    # lsps, easier to install globally
    zls
    rust-analyzer
    nil
    tinymist
    glslls
    #clang-tools

    gcc

    zig
    opam
    gnumake
    # clang
    arduino-ide
    # agda 
    # agdaPackages.standard-library
    # haskellPackages.agda-language-server
    idris2
    idris2Packages.idris2Lsp
    idris2Packages.idris2Api

    man-pages
    linux-manual

    # bintools
    gdb
    ghidra


    grandorgue
    qsynth
    mpv
    mpc-cli

    victor-mono
    cascadia-code
    lmmath
    lmodern
    oswald
    noto-fonts

    imhex

    mgba
    appimage-run

    file
    ffmpeg

    # localsend

    # direnv
    # nix-direnv

    (callPackage ./pkgs/riverbsp.nix {})
  ];

  bitshift = x: y: 
    assert builtins.isInt x;
    assert builtins.isInt y;
    if y == 0 then
       x
    else if y > 0 then
       bitshift (x * 2) (y - 1)
    else
       bitshift (x / 2) (y + 1);

  river-tags = builtins.genList (x: x) 9;

  mk-symlink = path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/babelfish-files/${path}";
in
{
  programs.home-manager.enable = true;

  # nixpkgs.overlays = [

  #     (self: super: {
  #       glfw = super.glfw.overrideAttrs (finalAttrs: previousAttrs:
  #         with super; {
  #           postPatch = lib.optionalString stdenv.isLinux ''
  #             substituteInPlace src/wl_init.c \
  #               --replace-fail "libxkbcommon.so.0" "${lib.getLib libxkbcommon}/lib/libxkbcommon.so.0" \
  #               --replace-fail "libdecor-0.so.0" "${lib.getLib libdecor}/lib/libdecor-0.so.0" \
  #               --replace-fail "libwayland-client.so.0" "${lib.getLib wayland}/lib/libwayland-client.so.0" \
  #               --replace-fail "libwayland-cursor.so.0" "${lib.getLib wayland}/lib/libwayland-cursor.so.0" \
  #               --replace-fail "libwayland-egl.so.1" "${lib.getLib wayland}/lib/libwayland-egl.so.1"
  #           '';
  #         });
  #       imhex = super.imhex.overrideAttrs (finalAttrs: previousAttrs: let
  #         patterns_version = "1.35.3";
  #         patterns_src = super.fetchFromGitHub {
  #           owner = "WerWolv";
  #           repo = "ImHex-Patterns";
  #           rev = "ImHex-v${patterns_version}";
  #           hash = "sha256-h86qoFMSP9ehsXJXOccUK9Mfqe+DVObfSRT4TCtK0rY=";
  #         };
  #       in rec {
  #         version = "1.35.3";
  #         src = super.fetchFromGitHub {
  #           fetchSubmodules = true;
  #           owner = "WerWolv";
  #           repo = previousAttrs.pname;
  #           rev = "v${version}";
  #           hash = "sha256-8vhOOHfg4D9B9yYgnGZBpcjAjuL4M4oHHax9ad5PJtA=";
  #         };
  #         nativeBuildInputs = with super; [
  #           autoPatchelfHook
  #           cmake
  #           llvm
  #           python3
  #           perl
  #           pkg-config
  #           rsync
  #         ];
  #         autoPatchelfIgnoreMissingDeps = ["*.hexpluglib"];
  #         appendRunpaths = [
  #           (super.lib.makeLibraryPath [super.libGL])
  #           "${placeholder "out"}/lib/imhex/plugins"
  #         ];
  #         postInstall = ''
  #           mkdir -p $out/share/imhex
  #           rsync -av --exclude="*_schema.json" ${patterns_src}/{constants,encodings,includes,magic,patterns} $out/share/imhex
  #         '';
  #       });
  #     })

  #     ];
  home = {
    inherit username homeDirectory packages;
    stateVersion = "24.05";
    file."/home/alex/.XCompose".source = mk-symlink "config/xcompose/.XCompose";
    file."/home/alex/.config/nvim".source = mk-symlink "config/nvim";
    file."/home/alex/.config/sway".source = mk-symlink "config/sway";



    sessionVariables = {
      MANPAGER = "nvim +Man!";
      MANWIDTH = "72";
      _JAVA_AWT_WM_NONREPARENTING= "1";
      AWT_TOOLKIT="MToolkit";
      DEVKITPRO="/home/alex/software/devkitPro/buildscripts-devkitPPC_r46.1/opt/devkitpro";
      DEVKITARM="/home/alex/software/devkitPro/buildscripts-devkitPPC_r46.1/opt/devkitpro/devkitARM";
    };

    pointerCursor = {
      name = "phinger-cursors-dark";
      package = pkgs.phinger-cursors;
      size = 32;
      gtk.enable = true;
    };
  };

  programs.firefox.enable = true;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [ 
      seoul256-vim
      nvim-lspconfig
      nvim-nu
      nvim-lastplace
      nvim-tree-lua
      vim-lion

      nvim-cmp
      cmp-path
      cmp-nvim-lsp
      nvim-surround
      Coqtail
      coq-lsp-nvim
      idris2-nvim
      nui-nvim
      typst-preview-nvim

      (nvim-treesitter.withPlugins (p: 
      let 
        nu_grammar = pkgs.tree-sitter.buildGrammar {
          language = "nu";
          version = "0.0.0+786689b";
          src = pkgs.fetchFromGitHub {
            owner = "LhKipp";
            repo = "tree-sitter-nu";
            rev = "ef943c6f2f7bfa061aad7db7bcaca63a002f354c";
            hash = "sha256-U7IHAXo3yQgbLv7pC1/dOa/cXte+ToMc8QsDEiCMSRg=";
          };
        };
      in
      [ p.c p.cpp p.glsl p.java p.lua p.nix nu_grammar p.rust p.typst p.vim p.vimdoc p.zig ]))
    ];
  };

  programs.helix = {
    enable = true;
    languages = {
      language-server.tinymist = {
        command = "${pkgs.tinymist}/bin/tinymist";
        config = {
          exportPdf = "onSave";
        };
      };
      language = [
          {
            name = "typst";
            auto-format = true;
            file-types = [ "typ" ];
            indent = {
              tab-width = 2;
              unit = "  ";
            };
            formatter.command = "${pkgs.typstyle}/bin/typstyle";
            language-servers = [ "tinymist" ];
          }
      ]; 
    };
    settings = {
      theme = "gruvbox";
      editor = {
        line-number = "relative";
        color-modes = true;
        smart-tab.enable = false;
        soft-wrap.enable = true;
        cursor-shape = {
          insert = "block";
          normal = "block";
          select = "underline";
        };
        lsp.display-messages = true;
        search.smart-case = false;
        bufferline = "multiple";
        jump-label-alphabet = "ghfjdksla;tyvbrucneixmwoz";
        inline-diagnostics.cursor-line = "warning";
      };
      keys = {
        normal = {
          X = [
            "extend_line_up"
            "extend_to_line_bounds"
          ];
          A-j = "insert_newline";
          ret = "goto_word";
          C-h = "goto_previous_buffer";
          C-l = "goto_next_buffer";
        };
        insert = {
          C-h = "signature_help";
        };
      }; 
    };
  };

  programs.emacs.enable = true;


  wayland.windowManager.river = 
  with builtins; let

    mkTagKeys = i:{
      "Super ${toString (i + 1)}" = "set-focused-tags ${toString (bitshift 1 i)}";
      "Super+Shift ${toString (i + 1)}" = "set-view-tags ${toString (bitshift 1 i)}";
    };
    tagKeys = foldl' (acc: x: acc // mkTagKeys x) {} river-tags;
    
  in {
    enable = true;
    settings = {
      border-width = 2;
      declare-mode = [ "normal" ];
      map = {
        "-repeat".normal = {
          "None XF86AudioRaiseVolume"  = "spawn 'pamixer -i 5'";
          "None XF86AudioLowerVolume"  = "spawn 'pamixer -d 5'";

          "None XF86AudioNext" = "spawn 'mpc next'";
          "None XF86AudioPrev" = "spawn 'mpc prev'";
          "None XF86AudioPlay" = "spawn 'mpc toggle'";

          "None XF86MonBrightnessUp"   = "spawn 'brightnessctl set +5%'";
          "None XF86MonBrightnessDown" = "spawn 'brightnessctl set 5%-'";
        };
        normal = {
          "Super Q" = "close";
          "Super+Shift E" = "exit";
          "Super Return" = "spawn kitty";
          "Super F" = "toggle-fullscreen";

          "Super K" = "focus-view up";
          "Super J" = "focus-view down";
          "Super H" = "focus-view left";
          "Super L" = "focus-view right";
          "Super+Shift J" = "swap next";
          "Super+Shift K" = "swap previous";

          "Super P" = "focus-output previous";
          "Super N" = "focus-output next";
          "Super+Shift P" = "send-to-output previous";
          "Super+Shift N" = "send-to-output next";

          "Super+Shift H" = "send-layout-cmd rivertile \"main-count +1\"";
          "Super+Shift L" = "send-layout-cmd rivertile \"main-count -1\"";

          "Super+Control+Shift H" = "send-layout-cmd rivertile \"main-ratio -0.05\"";
          "Super+Control+Shift L" = "send-layout-cmd rivertile \"main-ratio +0.05\"";

          "Super Space" = "spawn 'rofi -show drun'";

          "Super+Shift Y"         = "spawn 'sh -c '\"'\"'grim -g \"$(slurp)\" - | wl-copy -t image/png'\"'\"";
          "Control+Super+Shift Y" = "spawn 'sh -c '\"'\"'grim -g \"$(slurp)\" /tmp/screenshot.png; mv /tmp/screenshot.png \"$(yad --file --save)\"'\"'\"";
          "Super Y"               = "spawn 'sh -c '\"'\"'grim - | wl-copy -t image/png'\"'\"";
          "Control+Super Y"       = "spawn 'sh -c '\"'\"'grim /tmp/screenshot.png; mv /tmp/screenshot.png \"$(yad --file --save)\"'\"'\"";

          "None XF86AudioMute"         = "spawn 'pamixer --toggle-mute'";

          "Super M" = "spawn 'kitty ncmpcpp'";
          "Super C" = "spawn qalculate-qt";

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
        "'*Touchpad'" = {
          scroll-factor = "0.1";
          events = true;
          click-method = "clickfinger";
          tap = false;
          pointer-accel = 0.3;
          accel-profile = "adaptive";
          natural-scroll = true;
          tap-button-map = "left-right-middle";
          scroll-method = "two-finger";
        };
      };
      rule-add."-app-id" = {
        "'*qjackctl*'" = "float";
        "'*qalculate*'" = "float";
      };
    };
    extraSessionVariables = { 
      XDG_CURRENT_DESKTOP = "river";
      QT_QPA_PLATFORM = "wayland";
      MOZ_ENABLE_WAYLAND = 1;
      _JAVA_AWT_WM_NONREPARENTING = 1;
      AWT_TOOLKIT = "MToolkit";
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

  # programs.nushell = {
  #   enable = true;
  #   configFile.source = ./config/nushell/config.nu;
  #   envFile.source = ./config/nushell/env.nu;
  # };
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    dotDir = ".config/zsh";
    history = {
      share = true;
      ignoreAllDups = true;
      size = 50000;
      path = "/home/alex/.cache/zsh_histfile";
    };
    autocd = true;
    initContent = builtins.readFile ./config/zsh/.zshrc;
    shellAliases = {
      cdc = "cd ~/babelfish-files/";
      cdh = "cd ~/dropbox-maestral/Alex_home/";
      cdu = "cd ~/dropbox-maestral/Alex_University/";
      ffmpeg = "ffmpeg -hide_banner";
    };
  };

  programs.kitty = {
    enable = true;
    settings = {
      touch_scroll_multiplier = "8.0";
      wheel_scroll_multiplier = "8.0";
      enable_audio_bell = false;
      font_features = "CascadiaMonoNF-Regular +calt +ss01 +ss19";
      cursor_blink_interval = 0;
    };
    font.name = "Cascadia Mono NF";
    extraConfig = builtins.readFile ./config/kitty/seoul256.conf;
  };

  programs.waybar = {
    enable = true;
    settings.mainBar = {
      position = "top";
      height = 32;
      spacing = 4;
      modules-left = [
        "sway/workspaces" "mpd"
      ];
      modules-center = [
        "sway/window"
      ];
      modules-right = [
        "tray"
        "idle_inhibitor"
        "pulseaudio"
        "network"
        "battery"
        "clock"
      ];
      network = {
        format-wifi = "{essid} ({signalStrength}%) ";
        format-ethernet = " {ifname}";
        tooltip-format = " {ifname} via {gwaddr}";
        format-linked = " {ifname} (No IP)";
        format-disconnected = "Disconnected ⚠ {ifname}";
        format-alt = " {ifname}: {ipaddr}/{cidr}";
      };
      pulseaudio = {
        scroll-step = 5;
        format = "{icon} {volume}% {format_source}";
        format-bluetooth = " {icon} {volume}% {format_source}";
        format-bluetooth-muted = "  {icon} {format_source}";
        format-muted = "  {format_source}";
        format-source = " {volume}%";
        format-source-muted = "";
        format-icons.default = ["" "" ""];
        on-click = "pavucontrol";
        on-click-right = "foot -a pw-top pw-top";
      };
      battery = {
        states = {
            warning = 30;
            critical = 15;
        };
        format = "{icon} {capacity}%";
        format-charging = " {capacity}%";
        format-plugged = " {capacity}%";
        format-alt = "{icon} {time}";
        format-icons = ["" "" "" "" ""];
      };
      clock = {
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        format = "{:L%Y-%m-%d %a %I:%M %p}";
      };
      tray.spacing = 10;
    };

  };


  programs.ssh.enable = true;
  programs.ssh.matchBlocks = {
    comp3703 = {
      port = 5555;
      hostname = "localhost";
      user = "user1";
    };
    "*.moma" = {
      user = "alexm";
      proxyJump = "alexm@bullfrog.anu.edu.au";
    };
    "fran" = {
      hostname = "fran.gpu";
      proxyJump = "u7469202@bulwark.cecs.anu.edu.au";
      user = "u7469202";
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      jdinhlife.gruvbox
      ms-vscode-remote.remote-ssh
    ];
  };

  services.mpd = {
    enable = true;
    musicDirectory = homeDirectory + "/music";
    dataDir = homeDirectory + "/.local/share/mpd";
    extraConfig = 
    ''
      audio_output {
          type            "pipewire"
          name            "PipeWire Sound Server"
      }
    '';
  };

  programs.ncmpcpp = {
    enable = true;
    bindings = [
      { key = "j"; command = "scroll_down"; }
      { key = "J"; command = ["select_item" "scroll_down"]; }
      { key = "k"; command = "scroll_up"; }
      { key = "K"; command = [ "select_item" "scroll_up" ]; }
      { key = "l"; command = "next_column"; }
      { key = "l"; command = "slave_screen"; }
      { key = "h"; command = "previous_column"; }
      { key = "h"; command = "master_screen"; }
      { key = "d"; command = "delete_playlist_items"; }
      { key = "d"; command = "delete_browser_items"; }
      { key = "d"; command = [ "delete_stored_playlist" ]; }
    ];
    settings = {
      ncmpcpp_directory = homeDirectory + "/.local/share/ncmpcpp";
    };
  };

  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = homeDirectory + "/dropbox-maestral/Alex_home/passwords/";
    };
  };
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-curses;
  };


# Not working
  systemd.user.services.maestral-start = {
    Unit = {
      Description = "Start maestral on startup";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      ExecStart = "${pkgs.maestral}/bin/maestral start -f -v";
      Type = "simple";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  fonts.fontconfig.enable = true;
}
