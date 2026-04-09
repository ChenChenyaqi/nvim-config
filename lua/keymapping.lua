-- 插入模式下的方向键映射
vim.keymap.set("i", "<C-h>", "<Left>")
vim.keymap.set("i", "<C-l>", "<Right>")
vim.keymap.set("i", "<C-j>", "<Down>")
vim.keymap.set("i", "<C-k>", "<Up>")

-- 普通模式下的窗口切换
-- vim.keymap.set("n", "<C-h>", "<C-w>h")
-- vim.keymap.set("n", "<C-l>", "<C-w>l")
-- vim.keymap.set("n", "<C-j>", "<C-w>j")
-- vim.keymap.set("n", "<C-k>", "<C-w>k")

-- 快速移动（普通模式和可视模式）
-- Shift+J: 向下移动5行
vim.keymap.set({ "n", "v" }, "<S-J>", "5j")
-- Shift+K: 向上移动5行
vim.keymap.set({ "n", "v" }, "<S-K>", "5k")

-- 行首行尾快速移动（普通、可视、操作符模式）
-- Shift+H: 移动到行首
vim.keymap.set({ "n", "x", "o" }, "<S-H>", "^", { desc = "Start of line" })
-- Shift+L: 移动到行尾
vim.keymap.set({ "n", "x", "o" }, "<S-L>", "$", { desc = "End of line" })

-- 退出和保存操作（普通和可视模式）
-- Q: 退出所有文件
vim.keymap.set({ "n", "x" }, "Q", "<CMD>:qa<CR>")
-- qq: 退出当前文件
vim.keymap.set({ "n", "x" }, "qq", "<CMD>:q<CR>")
-- Ctrl+s: 保存文件
vim.keymap.set({ "n", "x" }, "<C-s>", "<CMD>:w<CR>", { desc = "Save file" })
-- 手动格式化当前缓冲区或选区
vim.keymap.set({ "n", "x" }, "<leader>fm", function()
  require("conform").format({ async = false, lsp_format = "fallback" })
end, { desc = "Format file" })

-- 清空查询时的高亮
vim.keymap.set("n", "<leader>l", "<CMD>noh<CR>", { desc = "Clear highlight" })
-- 快速替换当前单词
vim.keymap.set(
  "n",
  "<leader>r",
  "*:%s/<C-r><C-w>//gc<Left><Left><Left>",
  { desc = "Replace current word ignoring case", noremap = true }
)

-- 删除函数
vim.keymap.set("n", "<leader>df", "V$%d", { desc = "Delete a function" })
-- 复制函数
vim.keymap.set("n", "<leader>cf", "V$%y", { desc = "Copy a function" })

-- code action
vim.keymap.set("n", "<A-.>", vim.lsp.buf.code_action, {})

vim.keymap.set("n", "<leader>sq", function()
  vim.diagnostic.setqflist({ open = true, bufnr = 0 })
end, { desc = "Show buffer diagnostics in Quickfix" })
