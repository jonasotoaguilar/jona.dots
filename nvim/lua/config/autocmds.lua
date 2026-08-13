-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Treat OpenCode temp markdown files as plain text so markdown tools do not attach
vim.filetype.add({
  pattern = {
    ["/tmp/.*%.md"] = "text",
  },
})
