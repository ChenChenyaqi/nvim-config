return {
  -- 自动括号匹配
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      ignored_next_char = "[%w%.]", -- 忽略字母数字和点符号后的自动配对，避免在这些字符后产生不必要的配对
    },
  },
  -- 智能注释插件
  {
    "numToStr/Comment.nvim",
    -- stylua: ignore
    keys = {
      { "<leader>/", function() require("Comment.api").toggle.linewise.current() end,                 mode = "n", desc = "[Comment] Comment current line", },
      { "<leader>/", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", mode = "v", desc = "Comment current line", },
    },
    opts = {
      mappings = {
        basic = false,
        extra = false,
      },
    },
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
      "folke/snacks.nvim",
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

  {
    "kylechui/nvim-surround",
    version = "*", -- 使用最新稳定版
    event = "VeryLazy", -- 懒加载，非常快
    config = function()
      require("nvim-surround").setup({
        -- 这里可以留空，使用默认配置即可支持 ysiw, cs"', ds" 等操作
      })
    end,
  },

  {
    "mg979/vim-visual-multi",
    branch = "master",
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "gb",
        ["Find Subword Under"] = "gb",
        ["Select All"] = "ga",
      }
    end,
  },
}
