-- 语言配置主入口文件
-- 统一管理所有编程语言的配置

local M = {}

-- 导入所有语言配置模块
M.lua_config = require("lang.lua_config")
M.web_config = require("lang.web_config")
M.json_config = require("lang.json_config")
M.swift_config = require("lang.swift_config")
M.dart_config = require("lang.dart_config")
M.markdown_config = require("lang.markdown_config")

M.lang_table = {
  { "lua_ls", "ts_ls", "vue_ls", "eslint", "html", "cssls", "tailwindcss", "jsonls", "sourcekit" },
}

M.ensure_installed = {
  "lua-language-server",
  "typescript-language-server",
  "vue-language-server",
  "eslint-lsp",
  "prettierd",
  "html-lsp",
  "css-lsp",
  "tailwindcss-language-server",
  "json-lsp",
}

-- 获取所有 LSP 配置
M.get_all_lsp_configs = function(capabilities)
  return {
    -- Lua LSP
    M.lua_config.get_lsp_config(capabilities),

    -- Web 开发 LSP
    M.web_config.get_ts_lsp_config(capabilities),
    M.web_config.get_vue_lsp_config(capabilities),
    M.web_config.get_html_lsp_config(capabilities),
    M.web_config.get_css_lsp_config(capabilities),
    M.web_config.get_tailwind_lsp_config(capabilities),
    M.web_config.get_eslint_lsp_config(capabilities),

    -- JSON LSP
    M.json_config.get_json_lsp_config(capabilities),

    -- Swift LSP
    M.swift_config.get_swift_lsp_config(capabilities),
  }
end

-- 获取所有格式化配置
M.get_all_formatting_config = function()
  local configs = {}

  -- 合并所有格式化配置
  local function merge_configs(target, source)
    for k, v in pairs(source) do
      target[k] = v
    end
  end

  merge_configs(configs, M.lua_config.get_formatting_config())
  merge_configs(configs, M.web_config.get_web_formatting_config())
  merge_configs(configs, M.json_config.get_json_formatting_config())
  merge_configs(configs, M.swift_config.get_swift_formatting_config())
  merge_configs(configs, M.dart_config.get_dart_formatting_config())
  merge_configs(configs, M.markdown_config.get_markdown_formatting_config())

  return configs
end

-- 获取所有代码检查配置
M.get_all_linting_config = function()
  return M.web_config.get_web_linting_config()
end

return M
