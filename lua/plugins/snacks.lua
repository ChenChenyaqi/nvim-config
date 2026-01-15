return {

  {
    "folke/snacks.nvim",
    priority = 1000, -- 高优先级加载
    lazy = false, -- 非延迟加载
    ---@type snacks.Config
    opts = {
      -- ===========================================
      -- Snacks.nvim 配置说明
      -- ===========================================
      -- Snacks 是一个功能丰富的 Neovim 插件套件
      -- 提供文件管理、代码导航、Git 集成等多种增强功能
      -- ===========================================

      -- 大文件处理：启用对大文件的优化处理
      bigfile = { enabled = true },
      -- 仪表板：启用启动时的仪表板界面
      dashboard = { enabled = true },
      -- 文件浏览器：禁用内置文件浏览器（可能使用其他插件）
      explorer = { enabled = false },
      -- 图像显示：启用图像预览功能
      image = {
        enabled = true,
        -- 文档图像设置：不内联显示，不浮动显示，限制最大尺寸
        doc = { inline = false, float = false, max_width = 80, max_height = 40 },
        -- 数学公式设置：LaTeX 公式使用小字体
        math = { latex = { font_size = "small" } },
      },
      -- 缩进和范围高亮：启用缩进和代码范围高亮
      indent = {
        enabled = true,
        -- 动画效果：禁用缩进动画
        animate = {
          enabled = false,
        },
        -- 缩进设置：仅高亮当前作用域
        indent = {
          only_scope = true,
        },
        -- 作用域高亮：启用当前作用域高亮，并在作用域开始处显示下划线
        scope = {
          enabled = true, -- 启用当前作用域高亮
          underline = true, -- 在作用域开始处显示下划线
        },
        -- 代码块显示：将作用域渲染为代码块（顶级作用域除外）
        chunk = {
          enabled = true,
        },
      },
      -- 输入增强：启用输入增强功能
      input = { enabled = true },
      -- Lazygit 集成：启用 Lazygit 集成，但不自动配置
      lazygit = {
        enabled = true,
        configure = false,
      },
      -- 通知系统：启用通知功能，使用通知样式
      notifier = {
        enabled = true,
        style = "notification",
      },
      -- 选择器系统：启用文件、缓冲区等选择器功能
      picker = {
        enabled = true,
        -- 预览器设置
        previewers = {
          -- 差异预览：使用外部工具 delta 来显示差异
          diff = {
            builtin = false, -- 不使用内置差异预览，使用外部工具
            cmd = { "delta" }, -- 使用 delta 工具显示差异
          },
          -- Git 预览：使用外部 Git 命令预览 Git 输出
          git = {
            builtin = false, -- 不使用内置 Git 预览，使用外部 Git 命令
            args = {}, -- 传递给 Git 命令的额外参数
          },
        },
        -- 窗口和键盘映射设置
        win = {
          input = {
            keys = {
              ["<A-j>"] = { "list_down", mode = { "n", "i" } }, -- Alt+j：列表向下
              ["<A-k>"] = { "list_up", mode = { "n", "i" } }, -- Alt+k：列表向上
              ["<C-u>"] = { "preview_scroll_up", mode = { "n", "i" } }, -- Ctrl+u：预览向上滚动
              ["<C-d>"] = { "preview_scroll_down", mode = { "n", "i" } }, -- Ctrl+d：预览向下滚动
            },
          },
        },
        -- 布局设置：使用 Telescope 风格的布局
        layout = {
          preset = "telescope",
        },
      },
      -- 快速文件：启用快速文件切换功能
      quickfile = { enabled = true },
      -- 滚动动画：禁用滚动动画效果
      scroll = { enabled = false },
      -- 作用域文本对象：创建 `ii` 和 `ai` 文本对象，以及 `[i` 和 `]i` 跳转
      scope = {
        enabled = true,
        cursor = false,
      },

      -- 状态列：启用增强的状态列显示
      statuscolumn = { enabled = true },
      -- 终端：启用内置终端功能
      terminal = {
        enabled = true,
      },
      -- 单词导航：启用单词导航功能
      words = { enabled = true },
      -- 样式设置
      styles = {
        -- 终端样式设置
        terminal = {
          relative = "editor", -- 相对于编辑器定位
          border = "rounded", -- 圆角边框
          position = "float", -- 浮动位置
          backdrop = 60, -- 背景透明度 60%
          height = 0.9, -- 高度占编辑器 90%
          width = 0.9, -- 宽度占编辑器 90%
          zindex = 50, -- 层级 50
        },
      },
    },

    -- stylua: ignore
    -- ===========================================
    -- 键盘映射配置
    -- ===========================================
    keys = {
      -- 基础功能
      { "<A-w>",           function() require("snacks").bufdelete() end,                    desc = "[Snacks] Delete buffer" },                                 -- Alt+w：删除缓冲区
      { "<leader>si",      function() require("snacks").image.hover() end,                  desc = "[Snacks] Display image" },                                 -- leader+si：显示图像
      { "<A-i>",           function() require("snacks").terminal() end,                     desc = "[Snacks] Toggle terminal",          mode = { "n", "t" } }, -- Alt+i：切换终端

      -- 通知功能
      { "<leader>n",       function() require("snacks").notifier.show_history() end,        desc = "[Snacks] Notification history" },      -- leader+n：通知历史

      -- 顶部选择器和浏览器
      { "<leader><space>", function() require("snacks").picker.smart() end,                 desc = "[Snacks] Smart find files" }, -- leader+空格：智能查找文件

      -- 查找功能
      { "<leader>sb",      function() require("snacks").picker.buffers() end,               desc = "[Snacks] Buffers" },        -- leader+sb：缓冲区列表
      { "<leader>sf",      function() require("snacks").picker.files({exclude = {
        "**/node_modules/**",
        "**/dist/**",
        '**/.git/**'
      }}) end,                 desc = "[Snacks] Find files" },     -- leader+sf：查找文件
      { "<leader>sg",      function() require("snacks").picker.grep() end,                  desc = "[Snacks] Grep" }, -- leader+sg：全局 Grep
      { "<leader>sw", function() require("snacks").picker.grep_word() end, desc = "[Snacks] Visual selection or word", mode = { "n", "x" } },  -- 已注释：单词 Grep

      -- Git 功能
      { "<C-g>",           function() require("snacks").lazygit() end,                      desc = "[Snacks] Lazygit" },        -- Ctrl+g：打开 Lazygit
      { "<leader>ggl",     function() require("snacks").picker.git_log() end,               desc = "[Snacks] Git log" },        -- leader+ggl：Git 日志
      -- { "<leader>ggd",     function() require("snacks").picker.git_diff() end,              desc = "[Snacks] Git diff" },       -- leader+ggd：Git 差异
      { "<leader>ggb",     function() require("snacks").git.blame_line() end,               desc = "[Snacks] Git blame line" }, -- leader+ggb：Git 行级责备
      { "<leader>ggB",     function() require("snacks").gitbrowse() end,                    desc = "[Snacks] Git browse" },     -- leader+ggB：Git 浏览

      -- 搜索功能
      { '<leader>s"',      function() require("snacks").picker.registers() end,             desc = "[Snacks] Registers" },              -- leader+s"：寄存器
      { '<leader>s/',      function() require("snacks").picker.search_history() end,        desc = "[Snacks] Search history" },         -- leader+s/：搜索历史
      { "<leader>sA",      function() require("snacks").picker.autocmds() end,              desc = "[Snacks] Autocmds" },               -- leader+sA：自动命令
      { "<leader>s:",      function() require("snacks").picker.command_history() end,       desc = "[Snacks] Command history" },        -- leader+s:：命令历史
      { "<leader>sc",      function() require("snacks").picker.commands() end,              desc = "[Snacks] Commands" },               -- leader+sc：命令列表
      { "<leader>sH",      function() require("snacks").picker.help() end,                  desc = "[Snacks] Help pages" },             -- leader+sH：帮助页面
      { "<leader>sh",      function() require("snacks").picker.highlights() end,            desc = "[Snacks] Highlights" },             -- leader+sh：高亮组
      { "<leader>sj",      function() require("snacks").picker.jumps() end,                 desc = "[Snacks] Jumps" },                  -- leader+sj：跳转列表
      { "<leader>sk",      function() require("snacks").picker.keymaps() end,               desc = "[Snacks] Keymaps" },                -- leader+sk：键盘映射
      { "<leader>sl",      function() require("snacks").picker.loclist() end,               desc = "[Snacks] Location list" },          -- leader+sl：位置列表
      { "<leader>sm",      function() require("snacks").picker.marks() end,                 desc = "[Snacks] Marks" },                  -- leader+sm：标记
      { "<leader>sM",      function() require("snacks").picker.man() end,                   desc = "[Snacks] Man pages" },              -- leader+sM：手册页
      { "<leader>sp",      function() require("snacks").picker.lazy() end,                  desc = "[Snacks] Search for plugin spec" }, -- leader+sp：插件搜索
      -- { "<leader>sq",      function() require("snacks").picker.qflist() end,                desc = "[Snacks] Quickfix list" },          -- leader+sq：快速修复列表
      { "<leader>sr",      function() require("snacks").picker.resume() end,                desc = "[Snacks] Resume" },                 -- leader+sr：恢复搜索
      { "<leader>su",      function() require("snacks").picker.undo() end,                  desc = "[Snacks] Undo history" },           -- leader+su：撤销历史

      -- LSP 功能
      { "gd",              function() require("snacks").picker.lsp_definitions() end,       desc = "[Snacks] Goto definition" },        -- gd：跳转到定义
    },

    init = function()
      local Snacks = require("snacks")
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- ===========================================
          -- 延迟加载的初始化配置
          -- ===========================================

          -- 设置全局调试函数
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- 重载 print 函数，用于 `:=` 命令

          -- 创建各种切换映射
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>tw") -- leader+tw：切换换行
          -- 删除冲突的键盘映射
          vim.keymap.del("n", "grn")
          vim.keymap.del("n", "gra")
          vim.keymap.del("n", "grr")
          vim.keymap.del("n", "gri")

          -- 设置选择器光标行高亮
          vim.api.nvim_set_hl(0, "SnacksPickerListCursorLine", { bg = "#313244" })
        end,
      })
    end,
  },
}
