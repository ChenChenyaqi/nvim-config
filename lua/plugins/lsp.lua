-- LSP 插件配置 - 语言服务器协议、格式化、代码检查和诊断工具
return {
  -- Mason 插件 - LSP 服务器和工具管理器
  {
    "williamboman/mason.nvim",
    opts = function()
      local lange_config = require("lang")
      return {
        ensure_installed = lange_config.ensure_installed,
      }
    end,
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
  -- nvim-lspconfig - LSP 客户端配置
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp", "williamboman/mason.nvim" },

    -- 为每个 LSP 服务器直接配置
    config = function()
      -- 诊断信息显示配置
      vim.diagnostic.config({
        underline = false, -- 不显示下划线
        signs = false, -- 不显示侧边栏标记
        update_in_insert = false, -- 插入模式不更新诊断
        virtual_text = { spacing = 2, prefix = "●" }, -- 虚拟文本显示
        severity_sort = true, -- 按严重程度排序
        float = {
          border = "rounded", -- 浮动窗口圆角边框
        },
      })

      -- 获取 LSP 能力（来自补全插件）
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- 从 lang 主入口获取所有 LSP 配置
      local lang_config = require("lang")
      local all_lsp_configs = lang_config.get_all_lsp_configs(capabilities)

      -- 配置所有 LSP 服务器
      for _, lsp_config in ipairs(all_lsp_configs) do
        vim.lsp.config(lsp_config[1], lsp_config[2])
      end

      -- 启用所有配置的 LSP
      for _, lang_item in pairs(lang_config.lang_table) do
        vim.lsp.enable(lang_item)
      end

      -- LSP 快捷键映射 - 当语言服务器附加到当前缓冲区时
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          vim.keymap.set("n", "gh", vim.lsp.buf.hover, { desc = "Hover show document" }) -- 悬停显示文档
          vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, {
            buffer = ev.buf,
            desc = "[LSP] Show diagnostic",
          })
          vim.keymap.set("n", "<leader>gk", vim.lsp.buf.signature_help, { desc = "[LSP] Signature help" })
        end,
      })
    end,
  },
  -- lazydev.nvim - Lua 开发辅助工具
  {
    "folke/lazydev.nvim",
    ft = "lua", -- 只在 lua 文件加载
    opts = {
      library = {
        -- 当找到 "vim.uv" 时加载 luvit 类型
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  -- conform.nvim - 代码格式化插件
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- 在保存前触发
    opts = function()
      -- 从 lang 主入口获取所有格式化配置
      local lang_config = require("lang")
      local all_formatting_config = lang_config.get_all_formatting_config()

      -- 基础格式化配置
      local formatters_by_ft = {
        -- 默认格式化器 - 用于没有配置的文件类型
        ["_"] = { "trim_whitespace" }, -- 去除空白字符
      }

      -- 合并所有语言格式化配置
      for k, v in pairs(all_formatting_config) do
        formatters_by_ft[k] = v
      end

      return {
        formatters_by_ft = formatters_by_ft,

        -- 自动格式化开关
        format_on_save = function(_)
          -- 通过全局变量控制是否启用自动格式化
          if vim.g.enable_autoformat then
            return { timeout_ms = 500, lsp_format = "fallback" }
          end
        end,
      }
    end,
    init = function()
      vim.g.enable_autoformat = true
      require("snacks").toggle
        .new({
          id = "auto_format",
          name = "Auto format",
          get = function()
            return vim.g.enable_autoformat
          end,
          set = function(state)
            vim.g.enable_autoformat = state
          end,
        })
        :map("<leader>tf") -- <leader>tf 切换自动格式化
    end,
  },
  -- nvim-lint - 代码静态检查插件
  {
    "mfussenegger/nvim-lint",
    event = "BufWritePost", -- 在保存后触发
    config = function()
      -- 从 lang 主入口获取所有代码检查配置
      local lang_config = require("lang")
      local all_linting_config = lang_config.get_all_linting_config()

      -- 不同语言的检查器配置
      require("lint").linters_by_ft = all_linting_config

      -- 保存后自动运行代码检查
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          -- try_lint 根据文件类型运行对应的检查器
          require("lint").try_lint()
        end,
      })
    end,
  },
  -- trouble.nvim - 问题诊断列表插件
  {
    "folke/trouble.nvim",
    cmd = "Trouble", -- 命令模式加载
    -- 快捷键配置
    keys = {
      {
        "<A-j>",
        function()
          vim.diagnostic.jump({ count = 1 })
        end,
        mode = { "n" },
        desc = "Go to next diagnostic",
      },
      {
        "<A-k>",
        function()
          vim.diagnostic.jump({ count = -1 })
        end,
        mode = { "n" },
        desc = "Go to previous diagnostic",
      },
      {
        "<leader>gd",
        "<CMD>Trouble diagnostics toggle<CR>",
        desc = "[Trouble] Toggle buffer diagnostics",
      },
      {
        "<leader>gs",
        "<CMD>Trouble symbols toggle focus=false<CR>",
        desc = "[Trouble] Toggle symbols ",
      },
      {
        "<leader>gl",
        "<CMD>Trouble lsp toggle focus=false win.position=right<CR>",
        desc = "[Trouble] Toggle LSP definitions/references/...",
      },
      { "<leader>gL", "<CMD>Trouble loclist toggle<CR>", desc = "[Trouble] Location List" },
      { "<leader>gq", "<CMD>Trouble qflist toggle<CR>", desc = "[Trouble] Quickfix List" },

      -- 注释掉的快捷键（可选功能）
      -- { "grr", "<CMD>Trouble lsp_references focus=true<CR>",         mode = { "n" }, desc = "[Trouble] LSP references"                        },
      -- { "gD", "<CMD>Trouble lsp_declarations focus=true<CR>",        mode = { "n" }, desc = "[Trouble] LSP declarations"                      },
      -- { "gd", "<CMD>Trouble lsp_type_definitions focus=true<CR>",    mode = { "n" }, desc = "[Trouble] LSP type definitions"                  },
      -- { "gri", "<CMD>Trouble lsp_implementations focus=true<CR>",    mode = { "n" }, desc = "[Trouble] LSP implementations"                   },
    },

    specs = {
      "folke/snacks.nvim",
      opts = function(_, opts)
        return vim.tbl_deep_extend("force", opts or {}, {
          picker = {
            actions = require("trouble.sources.snacks").actions,
            win = {
              input = {
                -- 快捷键配置
                keys = {
                  ["<c-t>"] = { "trouble_open", mode = { "n", "i" } },
                },
              },
            },
          },
        })
      end,
    },
    opts = {
      focus = false, -- 不自动聚焦
      warn_no_results = false, -- 无结果时不警告
      open_no_results = true, -- 无结果时打开窗口
      preview = {
        type = "float", -- 预览窗口类型
        relative = "editor", -- 相对于编辑器
        border = "rounded", -- 圆角边框
        title = "Preview", -- 预览标题
        title_pos = "center", -- 标题居中
        position = { 0.3, 0.3 }, -- 位置
        size = { width = 0.6, height = 0.5 }, -- 大小
        zindex = 200, -- 层级
      },
    },

    config = function(_, opts)
      require("trouble").setup(opts)
      local symbols = require("trouble").statusline({
        mode = "lsp_document_symbols",
        groups = {},
        title = false,
        filter = { range = true },
        format = "{kind_icon}{symbol.name:Normal}",
        -- 以下行用于修复背景颜色
        -- 设置为要使用的 lualine 部分
        -- hl_group = "lualine_b_normal",
      })

      -- 将状态插入到 lualine
      opts = require("lualine").get_config()
      table.insert(opts.winbar.lualine_b, 1, {
        symbols.get,
        cond = symbols.has,
      })
      require("lualine").setup(opts)
    end,
  },
}
