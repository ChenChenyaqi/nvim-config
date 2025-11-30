return {
  {
    "rmagatti/auto-session",
    lazy = false,

    keys = {
      { "<leader>ps", "<CMD>AutoSession restore<CR>", desc = "[Auto Session] Restore session" },
      { "<leader>pS", "<CMD>AutoSession search<CR>", desc = "[Auto Session] Search session" },
      { "<leader>pD", "<CMD>AutoSession delete<CR>", desc = "[Auto Session] Delete session" },
    },

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      auto_restore = false,
      suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },

      -- 🔥 新增：忽略这些窗口，不要保存到会话中
      bypass_session_save_file_types = {
        -- 调试相关
        "dapui_console",
        "dapui_watches",
        "dapui_stacks",
        "dapui_breakpoints",
        "dapui_scopes",
        "dap-repl",
        -- 测试相关
        "neotest-output",
        "neotest-summary",
        "neotest-output-panel",
        -- 终端相关
        "terminal",
        "toggleterm",
      },
    },

    init = function()
      -- 🔥 修改：删除了 "terminal"，防止恢复死掉的终端进程导致报错
      vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions"
    end,
  },
}
