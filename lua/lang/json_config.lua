-- JSON 语言配置
local M = {}

-- 获取 JSON LSP 配置
M.get_json_lsp_config = function(capabilities)
  return {
    'jsonls',
    {
      capabilities = capabilities,
      filetypes = { 'json', 'jsonc' }
    }
  }
end

-- 获取 JSON 格式化配置
M.get_json_formatting_config = function()
  return {
    json = { "prettier" },
    jsonc = { "prettier" }
  }
end

return M