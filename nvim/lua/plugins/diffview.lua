-- Diffview: diffs y merge tools en Neovim (integrado con lazygit)
-- https://github.com/sindrets/diffview.nvim
return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
  keys = {
    { "<leader>gv", "<cmd>DiffviewOpen<CR>", desc = "Diffview (HEAD vs worktree)" },
    { "<leader>gV", "<cmd>DiffviewFileHistory<CR>", desc = "Diffview File History" },
  },
  opts = {
    view = {
      default = { layout = "diff2_horizontal" },
    },
    file_panel = {
      width = 35,
    },
  },
}
