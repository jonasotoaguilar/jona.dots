-- This file contains the configuration overrides for specific Neovim plugins.

return {
  -- Change configuration for trouble.nvim
  {
    -- Plugin: trouble.nvim
    -- URL: https://github.com/folke/trouble.nvim
    -- Description: A pretty list for showing diagnostics, references, telescope results, quickfix and location lists.
    "folke/trouble.nvim",
    -- Options to be merged with the parent specification
    opts = {
      use_diagnostic_signs = true,
      modes = {
        diagnostics = {
          filter = { severity = vim.diagnostic.severity.ERROR },
        },
      },
    },
  },

  -- Mason: limit concurrent installers to avoid race conditions
  {
    "mason-org/mason.nvim",
    opts = {
      max_concurrent_installers = 2,
    },
  },

  -- Remove inlay hints from default configuration
  {
    -- Plugin: nvim-lspconfig
    -- URL: https://github.com/neovim/nvim-lspconfig
    -- Description: Quickstart configurations for the Neovim LSP client.
    "neovim/nvim-lspconfig",
    event = "VeryLazy", -- Load this plugin on the 'VeryLazy' event
    opts = {
      diagnostics = {
        -- Keep diagnostics available internally, but only show errors in the UI.
        virtual_text = false,
        virtual_lines = false,
        signs = {
          severity = { min = vim.diagnostic.severity.ERROR },
        },
        underline = {
          severity = { min = vim.diagnostic.severity.ERROR },
        },
        float = {
          severity = { min = vim.diagnostic.severity.ERROR },
          severity_sort = true,
          source = "if_many",
        },
        severity_sort = true,
        update_in_insert = false,
      },
      inlay_hints = { enabled = false }, -- Disable inlay hints
      servers = {
        angularls = {
          -- Configuration for Angular Language Server
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern("angular.json", "project.json")(fname)
          end,
        },
        nil_ls = {
          -- Configuration for nil (Nix Language Server), already installed via nix
          cmd = { "nil" },
          autostart = true,
          mason = false, -- Explicitly disable mason management for nil_ls
          settings = {
            ["nil"] = {
              formatting = { command = { "nixpkgs-fmt" } },
            },
          },
        },
      },
    },
  },

  -- Keep warnings out of the statusline while preserving error counts.
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      for _, component in ipairs(opts.sections and opts.sections.lualine_c or {}) do
        if type(component) == "table" and component[1] == "diagnostics" then
          component.sections = { "error" }
          break
        end
      end
      return opts
    end,
  },
}
