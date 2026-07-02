-- crates.nvim: Cargo.toml 依赖快捷键 (buffer-local，仅影响 Cargo.toml)
-- 仅在 crates.nvim 已初始化时绑定，避免普通 .toml 报错
local ok, crates = pcall(require, "crates")
if not ok then
  return
end

local bufnr = vim.api.nvim_get_current_buf()
local map = function(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { silent = true, buffer = bufnr, desc = desc })
end

map("<leader>ct", crates.toggle, "[Crates] Toggle")
map("<leader>cr", crates.reload, "[Crates] Reload")
map("<leader>cv", crates.show_versions_popup, "[Crates] Show versions")
map("<leader>cf", crates.show_features_popup, "[Crates] Show features")
map("<leader>cd", crates.show_dependencies_popup, "[Crates] Show dependencies")
map("<leader>cu", crates.update_crate, "[Crates] Update crate (cursor)")
map("<leader>ca", crates.update_all_crates, "[Crates] Update all crates")
map("<leader>cU", crates.upgrade_crate, "[Crates] Upgrade crate (cursor)")
map("<leader>cA", crates.upgrade_all_crates, "[Crates] Upgrade all crates")
