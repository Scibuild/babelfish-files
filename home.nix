{username, homeDirectory}: { pkgs, ... }: 
let
  packages = with pkgs; [
  ];
in
{
  programs.home-manager.enable = true;

  home = {
    inherit username homeDirectory packages;
    stateVersion = "24.05";
    file.".Xcompose".source = ./config/xcompose/.XCompose;
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
	    (genList (x: mkTagKeys x) 8);
    
  in {
    enable = true;
    settings = {
      border-width = 2;
      declare-mode = [ "normal" ];
      map = {
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
        } // tagKeys;
      };
      map-pinter = { 
        normal = {
          "Super BTN_LEFT" = "move-view";
          "Super BTN_RIGHT" = "resize-view";
          "Super BTN_MIDDLE" = "toggle-float";
        };
      };
      keyboard-layout = "-options caps:escape,ralt:compose us";
      set-repeat = "50 300";
      default-layout = "rivertile";
    };
    extraConfig = ''
      rivertile -view-padding 6 -outer-padding 6 &
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

  programs.kitty = {
    enable = true;
  };
}
