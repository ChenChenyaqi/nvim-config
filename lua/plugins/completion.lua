-- blink.cmp 自动补全插件配置
-- 基于 Rust 的高性能 Neovim 补全引擎，支持多种补全源和智能补全
-- 主要功能：
--   - 多源补全：LSP、Copilot、路径、代码片段、缓冲区等
--   - 高性能模糊匹配：基于 Rust 的快速匹配算法
--   - 智能上下文感知：根据代码位置自动调整补全源
--   - 丰富的快捷键映射：支持多种操作模式
--   - 美观的 UI：可自定义的补全菜单和文档窗口

return {
  {
    "saghen/blink.cmp",
    -- optional: provides snippets for the snippet source
    dependencies = {
      -- 'rafamadriz/friendly-snippets'
      "nvim-tree/nvim-web-devicons",
      "onsails/lspkind.nvim",
      "fang2hou/blink-copilot",
      "folke/lazydev.nvim",
    },

    -- use a release tag to download pre-built binaries
    version = "1.*",
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 按键映射配置 - 定义补全菜单的各种操作快捷键
      -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
      -- 'super-tab' for mappings similar to vscode (tab to accept)
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- All presets have the following mappings:
      -- C-space: Open menu or open docs if already open
      -- C-n/C-p or Up/Down: Select next/previous item
      -- C-e: Hide menu
      -- C-k: Toggle signature help (if signature.enabled = true)
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      -- stylua: ignore
      keymap = {
        -- 自定义按键映射 - 如果命令/函数返回 false 或 nil，将运行下一个命令/函数
        -- 预设模式：none（无预设映射，完全自定义）
        -- If the command/function returns false or nil, the next command/function will be run.
        preset = "none",
        ["<A-j>"] = { function(cmp) return cmp.select_next({ auto_insert = false }) end, "fallback", },
        ["<A-k>"] = { function(cmp) return cmp.select_prev({ auto_insert = false }) end, "fallback", },
        ["<C-n>"] = { function(cmp) return cmp.select_next({ auto_insert = false }) end, "fallback", },
        ["<C-p>"] = { function(cmp) return cmp.select_prev({ auto_insert = false }) end, "fallback", },

        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },

        ["<Tab>"] = { function(cmp) return cmp.accept() end, "fallback", },
        ["<CR>"] = { function(cmp) return cmp.accept() end, "fallback", },
        -- Close current completion and insert a newline
        ["<S-CR>"] = { function(cmp)
          cmp.hide()
          return false
        end, "fallback", },

        -- Show/Remove completion
        ["<A-/>"] = { function(cmp) if cmp.is_menu_visible() then return cmp.hide() else return cmp.show() end end, "fallback", },

        ["<A-n>"] = { function(cmp) cmp.show({ providers = { "buffer" } }) end, },
        ["<A-p>"] = { function(cmp) cmp.show({ providers = { "buffer" } }) end, },
      },

      -- 外观配置 - 控制补全菜单的视觉样式
      appearance = {
        -- 'mono' (默认) 使用 'Nerd Font Mono' 或 'normal' 使用 'Nerd Font'
        -- 调整间距以确保图标对齐
        nerd_font_variant = "normal",
      },

      -- 补全源配置 - 定义启用哪些补全源及其优先级
      -- 默认启用的补全源列表，可以通过 `opts_extend` 在其他地方扩展而不需要重新定义
      sources = {
        -- 默认补全源 - 智能根据代码上下文选择补全源
        default = function()
          local success, node = pcall(vim.treesitter.get_node)
          -- 如果在注释中，只显示缓冲区补全
          if success and node and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
            return { "buffer" }
          else
            -- 正常代码中显示完整补全源
            return { "lazydev", "copilot", "lsp", "path", "snippets", "buffer" }
          end
        end,
        per_filetype = {
          codecompanion = { "codecompanion" },
        },

        -- 补全提供者配置 - 为每个补全源设置具体参数
        providers = {
          -- LazyDev 补全源 - Lua 开发辅助工具，提供插件配置补全
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- 使 lazydev 补全具有最高优先级（参见 `:h blink.cmp`）
            score_offset = 95,
          },
          -- GitHub Copilot 补全源 - AI 代码补全
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = 100, -- 最高优先级
            async = true, -- 异步补全
            opts = {
              kind_icon = "", -- Copilot 图标
              kind_hl = "DevIconCopilot", -- 高亮组
            },
          },
          -- 路径补全源 - 文件路径自动补全
          path = {
            score_offset = 95, -- 高优先级
            opts = {
              get_cwd = function(_)
                return vim.fn.getcwd() -- 获取当前工作目录
              end,
            },
          },
          -- 缓冲区补全源 - 当前文件中的文本补全
          buffer = {
            score_offset = 20, -- 较低优先级
          },
          -- LSP 补全源 - 语言服务器协议提供的智能补全
          lsp = {
            -- 从 LSP 提供者中过滤掉文本类型的补全项，因为已经有缓冲区提供者处理文本
            transform_items = function(_, items)
              return vim.tbl_filter(function(item)
                return item.kind ~= require("blink.cmp.types").CompletionItemKind.Text
              end, items)
            end,
            score_offset = 60,        -- 中等优先级
            fallbacks = { "buffer" }, -- 回退到缓冲区补全
          },
          -- 代码片段补全源 - 预定义的代码模板
          -- 在触发字符后隐藏代码片段（避免重复显示）
          -- 触发字符由源定义。例如，对于 Lua，触发字符是 ., ", '.
          snippets = {
            score_offset = 70, -- 较高优先级
            should_show_items = function(ctx)
              -- 不在触发字符后显示代码片段
              return ctx.trigger.initial_kind ~= "trigger_character"
            end,
            fallbacks = { "buffer" }, -- 回退到缓冲区补全
          },
          -- 命令行补全源 - 在命令行模式下的补全
          cmdline = {
            min_keyword_length = 2, -- 最小关键字长度
            -- 在执行 shell 命令时忽略命令行补全
            enabled = function()
              return vim.fn.getcmdtype() ~= ":" or not vim.fn.getcmdline():match("^[%%0-9,'<>%-]*!")
            end,
          },
        },
      },

      -- 模糊匹配配置 - 提供拼写容错和显著更好的性能
      -- （默认）使用 Rust 实现的模糊匹配器
      -- 你可以使用 `implementation = "lua"` 来使用 Lua 实现，或者使用 `implementation = "prefer_rust"`
      -- 在 Rust 模糊匹配器不可用时回退到 Lua 实现
      --
      -- 参见模糊匹配文档获取更多信息
      fuzzy = {
        implementation = "prefer_rust_with_warning", -- 优先使用 Rust 实现，不可用时警告
        sorts = {
          "exact",                                   -- 精确匹配
          -- 默认排序方式
          "score",                                   -- 匹配分数
          "sort_text",                               -- 排序文本
        },
      },

      -- 补全行为配置 - 控制补全的接受和显示行为
      completion = {
        -- 注意：一些 LSP 可能会自己添加自动括号
        accept = { auto_brackets = { enabled = true } },                  -- 自动添加括号
        list = { selection = { preselect = true, auto_insert = false } }, -- 预选但不自动插入
        -- 补全菜单配置
        menu = {
          border = "rounded", -- 圆角边框
          max_height = 20,    -- 最大高度
          -- 绘制配置 - 定义补全菜单的列和组件
          draw = {
            columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
            components = {
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  local icon = ctx.kind_icon
                  if icon then
                    -- Do nothing
                  elseif vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      icon = dev_icon
                    end
                  else
                    icon = require("lspkind").symbolic(ctx.kind, { mode = "symbol" })
                  end
                  return icon .. ctx.icon_gap
                end,
                -- Optionally, use the highlight groups from nvim-web-devicons
                -- You can also add the same function for `kind.highlight` if you want to
                -- keep the highlight groups in sync with the icons.
                highlight = function(ctx)
                  local hl = ctx.kind_hl
                  if hl then
                    -- Do nothing
                  elseif vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      hl = dev_hl
                    end
                  end
                  return hl
                end,
              },
            },
          },
        },
        -- 文档窗口配置 - 显示补全项的详细文档
        documentation = {
          auto_show = true,         -- 自动显示文档
          -- 显示文档窗口前的延迟
          auto_show_delay_ms = 200, -- 200 毫秒延迟
          -- 文档窗口配置
          window = {
            min_width = 10,
            max_width = 120,
            max_height = 20,
            border = "rounded",
            winblend = 0,
            winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
            -- Note that the gutter will be disabled when border ~= 'none'
            scrollbar = true,
            -- Which directions to show the documentation window,
            -- for each of the possible menu window directions,
            -- falling back to the next direction when there's not enough space
            direction_priority = {
              menu_north = { "e", "w", "n", "s" },
              menu_south = { "e", "w", "s", "n" },
            },
          },
        },
        -- 幽灵文本配置 - 在当前行显示选中项的预览
        ghost_text = {
          enabled = true, -- 启用幽灵文本
          -- 当有项被选中时显示幽灵文本
          show_with_selection = true,
          -- 当没有项被选中时显示幽灵文本，默认为第一项
          show_without_selection = false,
          -- 当菜单打开时显示幽灵文本
          show_with_menu = true,
          -- 当菜单关闭时显示幽灵文本
          show_without_menu = true,
        },
      },

      -- 签名帮助配置 - 函数签名提示
      signature = {
        enabled = true, -- 启用签名帮助
        -- 签名帮助窗口配置
        window = {
          min_width = 1,
          max_width = 100,
          max_height = 10,
          border = "single", -- Defaults to `vim.o.winborder` on nvim 0.11+ or 'padded' when not defined/<=0.10
          winblend = 0,
          winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
          scrollbar = false, -- Note that the gutter will be disabled when border ~= 'none'
          -- Which directions to show the window,
          -- falling back to the next direction when there's not enough space,
          -- or another window is in the way
          direction_priority = { "n" },
          -- Disable if you run into performance issues
          treesitter_highlighting = true,
          show_documentation = true,
        },
      },

      -- 命令行补全配置 - 在命令行模式下的补全行为
      cmdline = {
        completion = {
          menu = {
            auto_show = true, -- 自动显示补全菜单
          },
        },
        -- stylua: ignore
        keymap = {
          preset = "none", -- 无预设映射，完全自定义
          ["<A-j>"] = { function(cmp) return cmp.select_next({ auto_insert = false }) end, "fallback", },
          ["<A-k>"] = { function(cmp) return cmp.select_prev({ auto_insert = false }) end, "fallback", },
          ["<C-p>"] = { function(cmp) return cmp.select_prev({ auto_insert = false }) end, "fallback", },
          ["<C-n>"] = { function(cmp) return cmp.select_next({ auto_insert = false }) end, "fallback", },
          ["<Tab>"] = { function(cmp) return cmp.accept() end, "fallback", },
          ["<CR>"] = { function(cmp)
            if vim.fn.getcmdtype() == ":" then return cmp.accept_and_enter() end
            return false
          end, "fallback", },
          ["<A-/>"] = { function(cmp) if cmp.is_menu_visible() then return cmp.hide() else return cmp.show() end end, "fallback", },
        },
      },
    },

    -- 配置扩展选项 - 允许在其他地方扩展这些配置而不需要重新定义
    opts_extend = { "sources.default" }, -- 允许扩展默认补全源
  },
}
