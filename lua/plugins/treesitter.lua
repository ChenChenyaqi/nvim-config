return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        auto_install = true,
        ensure_installed = {
          "c",
          "lua",
          "vim",
          "vimdoc",
          "query",
          "elixir",
          "heex",
          "javascript",
          "tsx",
          "html",
          "vue",
          "typescript",
          "css",
          "scss",
          "dart",
          "markdown",
          "markdown_inline",
        },
        sync_install = false,
        highlight = {
          enable = true,
        },
        indent = { enable = true, disable = { "vue", "dart" } },
      })
    end,
  },
}
