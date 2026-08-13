return {
  {
    -- Catppuccin Mocha (activo)
    {
      "catppuccin/nvim",
      name = "catppuccin",
      priority = 1000,
      opts = {
        flavour = "mocha",
        transparent_background = true,
        term_colors = true,
      },
    },
    -- {
    --   "xiyaowong/transparent.nvim",
    --   config = function()
    --     require("transparent").setup({
    --       extra_groups = { -- table/string: additional groups that should be cleared
    --         "Normal",
    --         "NormalNC",
    --         "Comment",
    --         "Constant",
    --         "Special",
    --         "Identifier",
    --         "Statement",
    --         "PreProc",
    --         "Type",
    --         "Underlined",
    --         "Todo",
    --         "String",
    --         "Function",
    --         "Conditional",
    --         "Repeat",
    --         "Operator",
    --         "Structure",
    --         "LineNr",
    --         "NonText",
    --         "SignColumn",
    --         "CursorLineNr",
    --         "EndOfBuffer",
    --       },
    --       exclude_groups = {}, -- table: groups you don't want to clear
    --     })
    --   end,
    -- },
    -- Alternativas de coloreschemes (comentadas para arranque rapido)
    -- {
    --   "Gentleman-Programming/gentleman-kanagawa-blur",
    --   name = "gentleman-kanagawa-blur",
    --   priority = 1000,
    -- },
    -- {
    --   "Alan-TheGentleman/oldworld.nvim",
    --   lazy = false,
    --   priority = 1000,
    --   opts = {},
    -- },
    -- {
    --   "rebelot/kanagawa.nvim",
    --   priority = 1000,
    --   lazy = true,
    --   config = function()
    --     require("kanagawa").setup({ ... })
    --   end,
    -- },
    {
      "LazyVim/LazyVim",
      opts = {
        colorscheme = "catppuccin",
      },
    },
  },
}
