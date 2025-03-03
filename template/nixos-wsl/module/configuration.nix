{
  config,
  pkgs,
  lib,
  ...
}: {

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  nix = {
    optimise.automatic = true;

    settings = {
      builders-use-substitutes = true;
      experimental-features = ["nix-command" "flakes"];
      flake-registry = builtins.toFile "null-flake-registry.json" ''{"flakes":[],"version":2}'';
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trusted-users = ["@wheel"];
      warn-dirty = false;
    };
  };

  networking.hostName = "nixos-wsl"; # Define your hostname.
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  # Shell configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = ["git" "docker" "docker-compose"];
      theme = "robbyrussell";
    };
  };

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.PermitRootLogin = "no";  

  # Disable unnecessary services in WSL
  services.xserver.enable = false;
  services.printing.enable = false;
  
  # Enable CUPS to print documents.
  #services.printing.enable = true;

  # Set timezone
  time.timeZone = "America/Los_Angeles";

  # Set zsh as default shell for all users
  users.defaultUserShell = pkgs.zsh;

  # Neovim configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    configure = {
      customRC = '''';  # Basic config, most will be in home-manager
    };
  };

  # WSL-specific optimizations
  environment.variables = {
    BROWSER = "wsl-open";
    EDITOR = "nvim";
  };
  
  # Enable interop with Windows
  environment.shellAliases = {
    # Add useful WSL-specific aliases
    "winhost" = "cat /etc/resolv.conf | grep nameserver | cut -d' ' -f2";  # Get Windows host IP
    "explorer" = "explorer.exe";  # Open Windows Explorer
    "code" = "code.exe";  # Use Windows VS Code
    # Add vim/neovim aliases
    "vim" = "nvim";
    "vi" = "nvim";
  };

  users.mutableUsers = false;

  system.stateVersion = "24.11";
} 