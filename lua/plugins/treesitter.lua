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
          "html",
          "vue",
          "typescript",
          "css",
          "scss",
        },
        sync_install = false,
        highlight = {
          enable = true,
          disable = { "vue" },
        },
        indent = { enable = true, disable = { "vue" } },
      })
    end,
  },
}
