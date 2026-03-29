-- Lua 语言配置函数
local M = {}

-- 获取 Lua LSP 配置
M.get_lsp_config = function(capabilities)
  return {
    "lua_ls",
    {
      capabilities = capabilities,
    },
  }
end

-- 获取 Lua 格式化配置
M.get_formatting_config = function()
  return {
    lua = { "stylua" },
  }
end

-- 获取 Lua 补全配置
M.get_completion_config = function()
  return {
    lazydev = {
      name = "LazyDev",
      module = "lazydev.integrations.blink",
      score_offset = 95,
    },
  }
end

return M
