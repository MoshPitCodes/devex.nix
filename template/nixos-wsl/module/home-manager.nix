{
  config,
  pkgs,
  ...
}: {
  # add home-manager user settings here
  home.packages = with pkgs; [git neovim];
  home.stateVersion = "24.11";

  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = config.home.username;
  home.homeDirectory = config.home.homeDirectory;


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Git configuration
  programs.git = {
    enable = true;
    userName = "moshpitcodes";
    userEmail = "4273661+MoshPitCodes@users.noreply.github.com";
  };

  # Zsh configuration
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
        "docker-compose"
      ];
      theme = "robbyrussell";
    };

    initExtra = ''
      # WSL-specific environment setup
      if [ -f /proc/sys/fs/binfmt_misc/WSLInterop ]; then
        # Add Windows PATH entries that might be useful
        WIN_HOME=$(wslpath `wslvar USERPROFILE`)
        export PATH="$PATH:$WIN_HOME/AppData/Local/Programs/Microsoft VS Code/bin"
      fi
    '';
  };

  # Neovim configuration
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    plugins = with pkgs.vimPlugins; [
      # Theme
      catppuccin-nvim
      
      # Essential plugins
      plenary-nvim
      nvim-web-devicons
      
      # File explorer
      nvim-tree-lua
      
      # Fuzzy finder
      telescope-nvim
      
      # LSP
      nvim-lspconfig
      mason-nvim
      mason-lspconfig-nvim
      
      # Completion
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      
      # Snippets
      luasnip
      cmp-luasnip
      
      # Treesitter
      (nvim-treesitter.withPlugins (p: [
        p.bash
        p.lua
        p.nix
        p.python
        p.rust
      ]))
    ];

    extraConfig = ''
      lua << EOF
      -- Basic settings
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.mouse = 'a'
      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      vim.opt.hlsearch = false
      vim.opt.wrap = true
      vim.opt.breakindent = true
      vim.opt.tabstop = 2
      vim.opt.shiftwidth = 2
      vim.opt.expandtab = true
      
      -- Theme setup
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
      })
      vim.cmd.colorscheme "catppuccin"
      
      -- Nvim-tree setup
      require("nvim-tree").setup()
      
      -- Telescope setup
      require("telescope").setup()
      
      -- LSP setup
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "nil_ls",
          "pyright",
          "rust_analyzer",
        },
      })
      
      -- Completion setup
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
        })
      })
      EOF
    '';
  };

  # Additional user packages
  home.packages = with pkgs; [
    # Development tools
    ripgrep
    fd
    fzf
  ];
} 