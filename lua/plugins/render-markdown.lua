return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  opts = {
    enabled = true,
    max_file_size = 10.0,
    render_modes = { "n", "c" },
    anti_conceal = {
      enabled = true,
    },
    heading = {
      sign = true,
      position = "overlay",
      width = "full",
    },
  },
}
