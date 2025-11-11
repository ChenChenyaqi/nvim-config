return {
  -- 自动括号匹配
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      ignored_next_char = "[%w%.]", -- 忽略字母数字和点符号后的自动配对，避免在这些字符后产生不必要的配对
    },
  },
  -- 自动删除行尾的多余空白字符
  {
    "cappyzawa/trim.nvim",
    event = "BufWritePre", -- 在保存文件前执行修剪
    opts = {},
  },
  -- 撤销树可视化
  -- 以树状结构可视化显示撤销历史，便于查看和回退到特定编辑状态
  {
    "mbbill/undotree",
    keys = {
      { "<leader>ut", "<cmd>UndotreeToggle<cr>", desc = "Toggle undo-tree" },
    },
    init = function() -- 设置持久化撤销，在 `~/.undodir` 目录保存撤销历史文件
      vim.cmd([[
      if has("persistent_undo")
         let target_path = expand('~/.undodir')

          " create the directory and any parent directories if the location does not exist.
          if !isdirectory(target_path)
              call mkdir(target_path, "p", 0700)
          endif

          let &undodir=target_path
          set undofile
      endif
      ]])
    end,
  },
  -- 智能注释插件
  {
    "numToStr/Comment.nvim",
    -- stylua: ignore
    keys = {
      { "<leader>/", function() require("Comment.api").toggle.linewise.current() end,                 mode = "n", desc = "[Comment] Comment current line", },
      { "<leader>/", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", mode = "v", desc = "Comment current line", },
      -- control + / keymappings
      { "<C-_>",     function() require("Comment.api").toggle.linewise.current() end,                 mode = "n", desc = "[Comment] Comment current line", },
      { "<C-_>",     "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", mode = "v", desc = "Comment current line", },
    },
    config = true,
  },
  -- 智能复制 增强系统剪贴板功能，支持 OSC52 协议，可在远程会话中复制文本
  {
    "ibhagwan/smartyank.nvim",
    event = { "BufWinEnter" },
    opts = {
      highlight = {
        timeout = 500, -- timeout for clearing the highlight
      },
      clipboard = {
        enabled = true,
      },
      osc52 = {
        silent = true, -- true to disable the "n chars copied" echo
      },
    },
  },

  -- "folke/flash.nvim", 快速跳转

  -- 高亮和管理代码中的 TODO、FIXME 等注释
  {
    "folke/todo-comments.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim"
    },
    event = "VeryLazy",
    -- stylua: ignore
    keys = {
      ---@diagnostic disable-next-line: undefined-field
      { "<leader>td", function() require("snacks").picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME", "BUG", "FIXIT", "HACK", "WARN", "ISSUE" } }) end, desc = "[TODO] Pick todos (without NOTE)", },
      ---@diagnostic disable-next-line: undefined-field
      { "<leader>tD", function() require("snacks").picker.todo_comments() end,                                                                                   desc = "[TODO] Pick todos (with NOTE)", },
    },
    config = true,
  },
  -- 增强文本对象 扩展 `a`（around）和 `i`（inside）文本对象，支持更多语法结构
  -- if/af 函数内外
  -- ic/ac class类内外
  -- im/am 方法内外
  -- ip/ap 段落内外
  -- i/a/ 注释
  {
    -- Extend `a`/`i` textobjects
    "echasnovski/mini.ai",
    version = "*",
    event = "BufReadPost",
    config = true,
  },
  -- 多光标编辑
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    event = "BufReadPost",
    keys = {
      -- Append/insert for each line of visual selections. Similar to block selection insertion.
      { "mI", function() require("multicursor-nvim").insertVisual() end, mode = "x", desc = "Insert cursors at visual selection" },
      { "mA", function() require("multicursor-nvim").appendVisual() end, mode = "x", desc = "Append cursors at visual selection" },
    },
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()

      -- Mappings defined in a keymap layer only apply when there are multiple cursors. This lets you have overlapping mappings.
      mc.addKeymapLayer(function(layerSet)
        -- Enable and clear cursors using escape.
        layerSet("n", "<esc>", function()
          mc.clearCursors()
        end)
      end)
    end,
  },
}
