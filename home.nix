{ pkgs, ... }: {
  imports = [];

  programs.home-manager.enable = true;
  home.packages = [ ];

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
}
