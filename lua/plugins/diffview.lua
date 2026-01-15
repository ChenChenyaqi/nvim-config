return {
  "sindrets/diffview.nvim",
  event = "VeryLazy",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
  keys = {
    { "<leader>ggd", "<cmd>DiffviewOpen<cr>", desc = "Open Diff View" }, -- 打开 Diff 视图
    { "<leader>ggh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" }, -- 查看当前文件历史
    { "<leader>ggc", "<cmd>DiffviewClose<cr>", desc = "Close Diff View" }, -- 关闭
  },
  config = function()
    require("diffview").setup({
      -- 可以在这里自定义配置，比如隐藏左侧文件栏等
      -- 默认配置已经非常接近 VS Code 了
      view = {
        -- 配置为双栏对比 (side-by-side)
        merge_tool = {
          layout = "diff3_mixed",
        },
      },
    })
  end,
}
