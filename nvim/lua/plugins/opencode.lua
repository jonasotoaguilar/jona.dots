-- OpenCode: agente de IA integrado con Neovim
-- https://github.com/nickjvandyke/opencode.nvim

-- Comando y opciones del terminal compartidos por el toggle y el server.start
local opencode_cmd = "opencode --port"
local terminal_opts = {
  win = {
    position = "left",
    enter = false,
  },
}

return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },
  keys = {
    {
      "<leader>aoa",
      function()
        require("snacks.terminal").toggle(opencode_cmd, terminal_opts)
      end,
      mode = { "n" },
      desc = "Toggle OpenCode",
    },
    {
      "<leader>aos",
      function()
        require("opencode").select()
      end,
      mode = { "n", "x" },
      desc = "OpenCode select",
    },
    {
      "<leader>aoi",
      function()
        require("opencode").ask("")
      end,
      mode = { "n", "x" },
      desc = "OpenCode ask",
    },
    {
      "<leader>aoI",
      function()
        require("opencode").ask("@this: ")
      end,
      mode = { "n", "x" },
      desc = "OpenCode ask with context",
    },
    {
      "<leader>aob",
      function()
        require("opencode").ask("@buffer ")
      end,
      mode = { "n", "x" },
      desc = "OpenCode ask about buffer",
    },
    {
      "<leader>aop",
      function()
        require("opencode").prompt("@this")
      end,
      mode = { "n", "x" },
      desc = "OpenCode prompt",
    },
    -- Built-in prompts
    {
      "<leader>aope",
      function()
        require("opencode").prompt("explain")
      end,
      mode = { "n", "x" },
      desc = "OpenCode explain",
    },
    {
      "<leader>aopf",
      function()
        require("opencode").prompt("fix")
      end,
      mode = { "n", "x" },
      desc = "OpenCode fix",
    },
    {
      "<leader>aopd",
      function()
        require("opencode").prompt("diagnostics")
      end,
      mode = { "n", "x" },
      desc = "OpenCode diagnose",
    },
    {
      "<leader>aopr",
      function()
        require("opencode").prompt("review")
      end,
      mode = { "n", "x" },
      desc = "OpenCode review",
    },
    {
      "<leader>aopt",
      function()
        require("opencode").prompt("test")
      end,
      mode = { "n", "x" },
      desc = "OpenCode test",
    },
    {
      "<leader>aopo",
      function()
        require("opencode").prompt("optimize")
      end,
      mode = { "n", "x" },
      desc = "OpenCode optimize",
    },
    {
      "<leader>aod",
      function()
        require("opencode").prompt("document")
      end,
      mode = { "n", "x" },
      desc = "OpenCode document",
    },
  },
  config = function()
    vim.g.opencode_opts = {
      server = {
        start = function()
          require("snacks.terminal").open(opencode_cmd, terminal_opts)
        end,
      },
    }
    vim.o.autoread = true
  end,
}
