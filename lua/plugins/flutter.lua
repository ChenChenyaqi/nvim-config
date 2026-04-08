return {
  {
    "nvim-flutter/flutter-tools.nvim",
    ft = "dart",
    cmd = {
      "FlutterRun",
      "FlutterDebug",
      "FlutterReload",
      "FlutterRestart",
      "FlutterQuit",
      "FlutterDevices",
      "FlutterEmulators",
      "FlutterDevTools",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap",
    },
    keys = {
      { "<leader>Fr", "<cmd>FlutterRun<cr>", desc = "[Flutter] Run" },
      { "<leader>FR", "<cmd>FlutterRestart<cr>", desc = "[Flutter] Restart" },
      { "<leader>Fq", "<cmd>FlutterQuit<cr>", desc = "[Flutter] Quit" },
    },
    opts = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      local dart_lsp_opts = require("lang.dart_config").get_dart_lsp_config(capabilities)[2]

      return {
        decorations = {
          statusline = {
            app_version = true,
            device = true,
          },
        },
        widget_guides = {
          enabled = true,
        },
        closing_tags = {
          enabled = true,
          highlight = "ErrorMsg",
          prefix = "// ",
        },
        dev_log = {
          enabled = true,
          open_cmd = "tabedit",
        },
        debugger = {
          enabled = true,
        },
        lsp = {
          capabilities = dart_lsp_opts.capabilities,
          settings = dart_lsp_opts.settings.dart,
          color = {
            enabled = true,
            background = false,
            virtual_text = true,
          },
        },
      }
    end,
    config = function(_, opts)
      require("flutter-tools").setup(opts)
    end,
  },
}
