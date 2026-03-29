-- Swift 语言配置
local M = {}

-- Swift LSP 配置
M.get_swift_lsp_config = function(capabilities)
  return {
    "sourcekit",
    {
      capabilities = capabilities,
      filetypes = { "swift", "objective-c", "objective-cpp" },
      cmd = { "sourcekit-lsp" },
      -- 目标平台由项目级 .sourcekit-lsp/config.json 控制
    },
  }
end

-- Swift 格式化配置
M.get_swift_formatting_config = function()
  return {
    swift = { "swift_format" },
  }
end

return M
