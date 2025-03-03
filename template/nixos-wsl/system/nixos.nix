{
  inputs,
  username,
  password,
}: system: let
  configuration = import ../module/configuration.nix;
  hardware-configuration = import /etc/nixos/hardware-configuration.nix; # copy this locally to no longer run --impure
  home-manager = import ../module/home-manager.nix;
  pkgs = inputs.nixpkgs.legacyPackages.${system};
in
  inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    
    # modules: allows for reusable code
    modules = [
      hardware-configuration
      configuration
      
      # Import the WSL module from nixpkgs
      inputs.nixpkgs.nixosModules.wsl

      {
        environment.systemPackages = with pkgs; [
          neovim
        ];

        # WSL doesn't need boot loader configuration
        boot.loader.systemd-boot.enable = false;
        boot.loader.efi.canTouchEfiVariables = false;

        users.users."${username}" = {
          extraGroups = ["networkmanager" "wheel"];
          home = "/home/${username}";
          isNormalUser = true;
          password = password;
        };

        # WSL-specific base configuration
        wsl = {
          enable = true;
          defaultUser = username;
          nativeSystemd = true;
          # Enable integration with Windows paths
          wslConf.automount.root = "/mnt";
          wslConf.automount.options = "metadata";
          wslConf.network.generateHosts = false;  # Use Windows hosts file
        };
      }

      inputs.home-manager.nixosModules.home-manager
      {
        # Add home-manager settings here
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users."${username}" = home-manager;
      }
      # Add more nix modules here
    ];
  } 