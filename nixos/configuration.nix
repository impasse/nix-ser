{ inputs, lib, config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  nixpkgs = {
    overlays = [
    ];
    config = {
      allowUnfree = true;
      allowBroken = false;

      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit pkgs;
        };
      };
    };
  };

  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 1d";
    };

    settings = {
      substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];
      
      experimental-features = [
        "nix-command"
        "flakes"
        "repl-flake"
      ];
      auto-optimise-store = true;
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    initrd.kernelModules = [ "amdgpu" ];

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        efiSupport = true;
        device = "nodev";
      };
    };

    extraModulePackages = with config.boot.kernelPackages; [ ];
  };

  time.timeZone = "Asia/Shanghai";

  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime
  ];

  hardware.opengl.driSupport = true;

  networking = {
    hostName = "nixos";

    firewall = {
      enable = false;
    };
    
    networkmanager = {
      enable = true;
    };

    proxy = {
      default = "http://192.168.31.102:6152";
      noProxy = "127.0.0.1,localhost,internal.domain";
    };
  };

  i18n = {
    defaultLocale = "zh_CN.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "zh_CN.UTF-8/UTF-8"
    ];
  };

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    fira-code
    fira-code-symbols
  ];

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  security = {
    sudo.wheelNeedsPassword = false;
  };

  environment.systemPackages = (with pkgs; [
    vim
    coreutils-full
    gcc
    gdb
    man
    zsh
    gitFull
    git-lfs
    gnumake
    wget
    fd
    bat
    ripgrep
    cacert
    bottom
    jq
    csvkit
    fzf
    highlight
    iftop
    vscode
    tmux
    imgcat
    lsof
    openssl
    sqlite
    aria
    axel
    htop
    procs
    httpie
    proxychains-ng
    inetutils
    nmap
    pcre
    nmon
    strace
    tldr
    unrar
    killall
    unzip
    dig
    exa
    gh
    ncdu
    xz
    zip
    pciutils
    usbutils
    mlocate
    go
    rustc
    cargo
    nodejs
    python
  ]);

  services = {
    openssh = {
      enable = true;
      allowSFTP = true;
      permitRootLogin = "prohibit-password";
    };

    locate = {
      enable = true;
      prunePaths = [ "/tmp" "/var/cache" "/var/lock" "/var/run" "/var/spool" ];
      interval = "hourly";
      locate = pkgs.mlocate;
      localuser = null;
    };
    
    xserver = {
      enable = true;
      displayManager.gdm.enable =  true;
      desktopManager.gnome.enable = true;

      videoDrivers = [ "amdgpu" ];
    };
  };

  documentation = {
    man.enable = true;
    info.enable = true;
  };

  programs = {
    mtr.enable = true;
    zsh.enable = true;
    htop.enable = true;
    iftop.enable = true;
    neovim.enable = true;
  };

  users = {
    defaultUserShell = pkgs.bash;

    users = {
      yooyi = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        shell = pkgs.zsh;
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwLGqoQdMyvVNiMjS86EXDyyDga3OCqQS2ddsMtJtN1crlbtxEuwoviAMPCOozbmV0bZoEc+ETwIGkoyZs61SKCBwQCjT8g07tivbCBUN9S5cC5BmsrbW3hoGiEgqcRrzE4RdcbkEMM6+HolesmHY6g/Fg+Ps9lnMgw+dYTcId40h+A49Vb8+gHRK8nRg8O/Jo53OanBDl/LPol7/tL+Slq4VyJdfLfse0msz9TBckA0affi+YGip0C3LIa0mPBojdzx78DTiPChA0aKTR5EdcTHOukG48yAUYnYo1pS2hVulhKwznUCdkUCsNEJ2sJYrazxWq7TQYd/v0L/Cs7s3t i@uuz.io"
        ];
      };
    };
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      yooyi = import ../home-manager;
    };
  };

  system.stateVersion = "22.11";
}
