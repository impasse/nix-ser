{ inputs, lib, config, pkgs, ... }:


{
  imports = [
  ];

  nixpkgs.config.allowUnfreePredicate = (_: true);

  home = {
    stateVersion = "22.11";

    packages = with pkgs; [
      neofetch
      tig
      you-get
      firefox
      scc
      delta
      nyancat
      ffmpeg
      firefox
    ];

    file.".config/pip/pip.conf".text = ''
    [global]
    index-url = https://pypi.tuna.tsinghua.edu.cn/simple
    '';

    file.".config/gem/gemrc".text = ''
    ---
    :backtrace: true
    :bulk_threshold: 1000
    :sources:
    - https://mirrors.tuna.tsinghua.edu.cn/rubygems/
    :update_sources: true
    :verbose: true
    :concurrent_downloads: 8
    '';

    file.".config/nixpkgs/config.nix".text = ''
    {
      allowBroken = false;

      allowUnfree = true;

      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit pkgs;
        };
      };
    }
    '';
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };

  programs.gpg = {
    enable = true;
  };

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = "Yooyi";
    userEmail = "i@uuz.io";
    aliases = {
      prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      root = "rev-parse --show-toplevel";
    };
    lfs = {
      enable = true;
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    shellAliases = {
      nix-search = "nix search nixpkgs";
      tree = "exa --tree";
      cat = "bat --style=plain";
      ll = "ls -ahl";
      du = "ncdu";
      df = "df -h";
    };
    oh-my-zsh = {
      enable = true;
      theme = "af-magic";
      plugins = [
        "dotenv"
        "direnv"
        "git"
      ];
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--info=inline"
      "--border"
      "--exact"
    ];
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-lastplace
      vim-nix
      vim-markdown
    ];
    withNodeJs = true;
    withPython3 = true;
    extraConfig = ''
      set nocompatible
      set backspace=indent,eol,start
      set mouse=
    '';
  };

  programs.go = {
    enable = true;
    goPath = "go";
  };
}
