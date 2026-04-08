-- Dart 语言配置
local M = {}

-- 获取 Dart LSP 配置
M.get_dart_lsp_config = function(capabilities)
  return {
    "dartls",
    {
      capabilities = capabilities,
      filetypes = { "dart" },
      settings = {
        dart = {
          completeFunctionCalls = true,
          showTodos = true,
          updateImportsOnRename = true,
        },
      },
    },
  }
end

-- 获取 Dart 格式化配置
M.get_dart_formatting_config = function()
  return {
    dart = { "dart_format" },
  }
end

return M
