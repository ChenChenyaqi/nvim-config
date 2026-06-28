-- Web 开发相关语言配置 (TypeScript, Vue, HTML, CSS)
local M = {}

-- 获取 VUE TS plugin 的路径(随 mason 的 vue-language-server 打包)
-- vue_ls 混合模式下,vtsls 需要加载此 plugin 才能解析 .vue 的 <script>
local function vue_ts_plugin_path()
  return vim.fn.stdpath("data")
    .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
end

-- 获取 Vtsls LSP 配置 (vue_ls 官方推荐的 TypeScript 档档)
-- 自 Volar v3 起,vue_ls 只管 <template>,<script lang="ts"> 需 vtsls + @vue/typescript-plugin
M.get_vtsls_lsp_config = function(capabilities)
  return {
    "vtsls",
    {
      capabilities = capabilities,
      -- 必须包含 vue,让 vtsls 也挂在 .vue buffer 上(vue_ls 混合模式需要它)
      filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
      settings = {
        vtsls = {
          tsserver = {
            globalPlugins = {
              {
                name = "@vue/typescript-plugin",
                location = vue_ts_plugin_path(),
                languages = { "vue" },
                configNamespace = "typescript",
              },
            },
          },
        },
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
    },
  }
end

-- 获取 Vue LSP 配置
M.get_vue_lsp_config = function(capabilities)
  return {
    "vue_ls",
    {
      capabilities = capabilities,
      filetypes = { "vue" },
    },
  }
end

-- 获取 HTML LSP 配置
M.get_html_lsp_config = function(capabilities)
  return {
    "html",
    {
      capabilities = capabilities,
      filetypes = { "html" },
    },
  }
end

-- 获取 CSS LSP 配置
M.get_css_lsp_config = function(capabilities)
  return {
    "cssls",
    {
      capabilities = capabilities,
      filetypes = { "css", "scss", "less" },
    },
  }
end

-- Tailwindcss LSP配置
M.get_tailwind_lsp_config = function(capabilities)
  return {
    "tailwindcss",
    {
      capabilities = capabilities,
      filetypes = {
        "html",
        "css",
        "scss",
        "less",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
      },
      init_options = {
        userLanguages = {
          html = "html",
          css = "css",
          scss = "css",
          less = "css",
          javascript = "javascript",
          javascriptreact = "javascriptreact",
          typescript = "typescript",
          typescriptreact = "typescriptreact",
          vue = "html",
        },
      },
      settings = {
        tailwindCSS = {
          includeLanguages = {
            html = "html",
            css = "css",
            scss = "css",
            less = "css",
            javascript = "javascript",
            javascriptreact = "javascriptreact",
            typescript = "typescript",
            typescriptreact = "typescriptreact",
            vue = "html",
          },
          experimental = {
            classRegex = {
              "cva\\(([^)]*)\\)",
              "cn\\(([^)]*)\\)",
              "tw`([^`]*)`",
              'tw="([^"]*)"',
              'tw={"([^"}]*)"}',
              "tw\\.\\w+`([^`]*)`",
              "tw\\(.*?\\)`([^`]*)`",
            },
          },
        },
      },
    },
  }
end

-- 获取 ESLint LSP 配置
M.get_eslint_lsp_config = function(capabilities)
  return {
    "eslint",
    {
      capabilities = capabilities,
      settings = {
        -- 使用项目中的 ESLint 配置
        useESLintClass = false,
        run = "onType", -- 输入时运行
        problems = {
          shortenToSingleLine = false,
        },
      },
    },
  }
end

-- 获取 Web 格式化配置
M.get_web_formatting_config = function()
  return {
    typescript = { "prettierd" },
    typescriptreact = { "prettierd" },
    javascript = { "prettierd" },
    javascriptreact = { "prettierd" },
    vue = { "prettierd" },
    html = { "prettierd" },
    css = { "prettierd" },
    scss = { "prettierd" },
    less = { "prettierd" },
  }
end

-- 获取 Web 代码检查配置
M.get_web_linting_config = function()
  return {
    typescript = { "eslint" },
    typescriptreact = { "eslint" },
    javascript = { "eslint" },
    javascriptreact = { "eslint" },
    vue = { "eslint" },
  }
end

return M
