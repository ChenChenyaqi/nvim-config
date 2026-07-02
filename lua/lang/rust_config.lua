-- Rust 语言配置: 仅格式化 (LSP 由 rustaceanvim 托管，故此处不提供 LSP 配置)
local M = {}

-- 获取 Rust 格式化配置
M.get_rust_formatting_config = function()
  return {
    rust = { "rustfmt" },
  }
end

return M
