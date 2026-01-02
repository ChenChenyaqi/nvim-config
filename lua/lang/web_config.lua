-- Web 开发相关语言配置 (TypeScript, Vue, HTML, CSS)
local M = {}

-- 获取 TypeScript LSP 配置
M.get_ts_lsp_config = function(capabilities, vue_language_server_path)
  return {
    "ts_ls",
    {
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
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    vue = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    less = { "prettier" },
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
