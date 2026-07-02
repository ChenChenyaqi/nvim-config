-- Rust 语言支持: rustaceanvim + crates.nvim
-- rust-analyzer 由 rustup 管理，rustaceanvim 自动复用，故不进入 lang 注册表、不经 Mason 安装
return {
  -- ========================================================================
  -- 1. rustaceanvim: rust-analyzer 集成 + Runnables + 调试 + 宏展开
  -- ========================================================================
  {
    "mrcjkb/rustaceanvim",
    version = "^8", -- v9 需 Neovim 0.12+，当前为 0.11.3 故用 v8(需 0.11+)
    lazy = false, -- 插件自带懒加载
    dependencies = { "mfussenegger/nvim-dap" },
    init = function()
      -- 用 function 形式，延迟 require blink，确保补全插件就绪后再取 capabilities
      vim.g.rustaceanvim = function()
        local ok, blink = pcall(require, "blink.cmp")
        local capabilities = ok and blink.get_lsp_capabilities() or nil
        return {
          tools = {
            executor = "termopen",
            test_executor = "background",
            enable_nextest = true,
            enable_clippy = true,
            reload_workspace_from_cargo_toml = true,
          },
          server = {
            auto_attach = true,
            capabilities = capabilities,
            default_settings = {
              ["rust-analyzer"] = {
                cargo = { allFeatures = true },
                check = { command = "clippy" },
                inlayHints = { enable = true },
              },
            },
          },
          dap = {
            autoload_configurations = true, -- rust-analyzer 就绪后自动注册 nvim-dap 配置
          },
        }
      end
    end,
  },

  -- ========================================================================
  -- 2. crates.nvim: Cargo.toml 依赖版本提示 / 更新 / 补全
  -- ========================================================================
  {
    "Saecki/crates.nvim",
    ft = { "toml" },
    config = function()
      require("crates").setup({
        src = {
          enabled = true,
          on_insert = true,
        },
        popup = { border = "rounded" },
      })
    end,
  },
}
