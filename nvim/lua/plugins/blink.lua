return {
  "saghen/blink.cmp",
  lazy = true,
  dependencies = { "saghen/blink.compat", "fang2hou/blink-copilot" },
  opts = {
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "copilot" },
      providers = {
        lsp = {
          name = "lsp",
          module = "blink.cmp.sources.lsp",
          score_offset = 60,
        },
        path = {
          name = "path",
          module = "blink.cmp.sources.path",
          score_offset = 50,
        },
        snippets = {
          name = "snippets",
          module = "blink.cmp.sources.snippets",
          score_offset = 40,
        },
        buffer = {
          name = "buffer",
          module = "blink.cmp.sources.buffer",
          score_offset = 30,
        },
        copilot = {
          name = "copilot",
          module = "blink-copilot",
          score_offset = 100,
          async = true,
        },
      },
    },
  },
}
