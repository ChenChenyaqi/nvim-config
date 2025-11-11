return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "typescript-language-server", -- TypeScript LSP
        "vue-language-server",        -- Vue LSP (新增)
        "eslint-lsp",                 -- ESLint LSP
        "prettier",                   -- prettier
        "html-lsp",                   -- HTML LSP
        "css-lsp",                    -- CSS LSP
        "json-lsp",                   -- JSON LSP
      },
    },
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
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp", "williamboman/mason.nvim" },

    -- example calling setup directly for each LSP
    config = function()
      vim.diagnostic.config({
        underline = false,
        signs = false,
        update_in_insert = false,
        virtual_text = { spacing = 2, prefix = "●" },
        severity_sort = true,
        float = {
          border = "rounded",
        },
      })

      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- 获取 vue-language-server 路径（使用标准 Mason 路径）
      local vue_language_server_path = vim.fn.stdpath('data') ..
      '/mason/packages/vue-language-server/node_modules/@vue/language-server'

      -- Lua LS 配置
      vim.lsp.config('lua_ls', {
        capabilities = capabilities
      })

      -- TypeScript LSP 配置 (支持 Vue 文件)
      vim.lsp.config('ts_ls', {
        capabilities = capabilities,
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
        init_options = {
          plugins = {
            {
              name = "@vue/typescript-plugin",
              location = vue_language_server_path,
              languages = { "vue" },
            },
          },
        },
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
      })

      -- Vue LSP 配置
      vim.lsp.config('vue_ls', {
        capabilities = capabilities,
        filetypes = { 'vue' }
      })

      -- HTML LSP 配置
      vim.lsp.config('html', {
        capabilities = capabilities,
        filetypes = { 'html' }
      })

      -- CSS LSP 配置
      vim.lsp.config('cssls', {
        capabilities = capabilities,
        filetypes = { 'css', 'scss', 'less' }
      })

      -- JSON LSP 配置
      vim.lsp.config('jsonls', {
        capabilities = capabilities,
        filetypes = { 'json', 'jsonc' }
      })

      -- ESLint LSP 配置
      vim.lsp.config('eslint', {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          -- 确保 ESLint 只对支持的文件类型工作
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
          })
        end,
        settings = {
          -- 使用项目中的 ESLint 配置
          useESLintClass = false,
          run = "onType",
          problems = {
            shortenToSingleLine = false,
          },
        },
      })

      -- 启用所有配置的 LSP
      vim.lsp.enable('lua_ls')
      vim.lsp.enable('ts_ls')
      vim.lsp.enable('vue_ls') -- 新增 Vue LSP
      vim.lsp.enable('eslint')
      vim.lsp.enable('html')
      vim.lsp.enable('cssls')
      vim.lsp.enable('jsonls')

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          vim.keymap.set("n", "gh", vim.lsp.buf.hover)
          vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, {
            buffer = ev.buf,
            desc = "[LSP] Show diagnostic",
          })
          vim.keymap.set("n", "<leader>gk", vim.lsp.buf.signature_help, { desc = "[LSP] Signature help" })
          vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "[LSP] Add workspace folder" })
          vim.keymap.set(
            "n",
            "<leader>wr",
            vim.lsp.buf.remove_workspace_folder,
            { desc = "[LSP] Remove workspace folder" }
          )
          vim.keymap.set("n", "<leader>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, { desc = "[LSP] List workspace folders" })
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "[LSP] Rename" })
        end,
      })
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  -- 格式化代码
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = {
      -- 不同语言的格式化配置
      formatters_by_ft = {
        lua = { "stylua" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        vue = { "prettier" }, -- 新增 Vue 格式化支持
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        less = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        -- Use the "_" filetype to run formatters on filetypes that don't
        -- have other formatters configured.
        ["_"] = { "trim_whitespace" },
      },

      -- 自动格式化开关
      format_on_save = function(_)
        -- Disable with a global or buffer-local variable
        if vim.g.enable_autoformat then
          return { timeout_ms = 500, lsp_format = "fallback" }
        end
      end,
    },
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
          :map("<leader>tf")
    end,
  },
  -- 代码静态检查
  {
    "mfussenegger/nvim-lint",
    event = "BufWritePost",
    config = function()
      require("lint").linters_by_ft = {
        typescript = { "eslint", "codespell" },
        typescriptreact = { "eslint", "codespell" },
        javascript = { "eslint", "codespell" },
        javascriptreact = { "eslint", "codespell" },
        vue = { "eslint", "codespell" }, -- 新增 Vue 代码检查支持
      }

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          -- try_lint without arguments runs the linters defined in `linters_by_ft`
          -- for the current filetype
          require("lint").try_lint()
        end,
      })
    end,
  },
  -- 问题诊断列表
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    -- stylua: ignore
    keys = {
      { "<A-j>",      function() vim.diagnostic.jump({ count = 1 }) end,            mode = { "n" },                                           desc = "Go to next diagnostic" },
      { "<A-k>",      function() vim.diagnostic.jump({ count = -1 }) end,           mode = { "n" },                                           desc = "Go to previous diagnostic" },
      { "<leader>gd", "<CMD>Trouble diagnostics toggle<CR>",                        desc = "[Trouble] Toggle buffer diagnostics" },
      { "<leader>gs", "<CMD>Trouble symbols toggle focus=false<CR>",                desc = "[Trouble] Toggle symbols " },
      { "<leader>gl", "<CMD>Trouble lsp toggle focus=false win.position=right<CR>", desc = "[Trouble] Toggle LSP definitions/references/...", },
      { "<leader>gL", "<CMD>Trouble loclist toggle<CR>",                            desc = "[Trouble] Location List" },
      { "<leader>gq", "<CMD>Trouble qflist toggle<CR>",                             desc = "[Trouble] Quickfix List" },

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
                -- stylua: ignore
                keys = {
                  ["<c-t>"] = { "trouble_open", mode = { "n", "i" }, },
                },
              },
            },
          },
        })
      end,
    },
    opts = {
      focus = false,
      warn_no_results = false,
      open_no_results = true,
      preview = {
        type = "float",
        relative = "editor",
        border = "rounded",
        title = "Preview",
        title_pos = "center",
        ---`row` and `col` values relative to the editor
        position = { 0.3, 0.3 },
        size = { width = 0.6, height = 0.5 },
        zindex = 200,
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
        -- The following line is needed to fix the background color
        -- Set it to the lualine section you want to use
        -- hl_group = "lualine_b_normal",
      })

      -- Insert status into lualine
      opts = require("lualine").get_config()
      table.insert(opts.winbar.lualine_b, 1, {
        symbols.get,
        cond = symbols.has,
      })
      require("lualine").setup(opts)
    end,
  },
}
