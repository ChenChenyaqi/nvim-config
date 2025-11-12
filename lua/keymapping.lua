-- 插入模式下的方向键映射
-- Ctrl+h: 向左移动
vim.keymap.set("i", "<C-h>", "<Left>")
-- Ctrl+l: 向右移动
vim.keymap.set("i", "<C-l>", "<Right>")
-- Ctrl+j: 向下移动
vim.keymap.set("i", "<C-j>", "<Down>")
-- Ctrl+k: 向上移动
vim.keymap.set("i", "<C-k>", "<Up>")

-- 插入模式下快速退出到普通模式
-- 输入 jk 退出插入模式
vim.keymap.set("i", "jk", "<Esc>")

-- 普通模式下的窗口切换
-- Ctrl+h: 切换到左边窗口
vim.keymap.set("n", "<C-h>", "<C-w>h")
-- Ctrl+l: 切换到右边窗口
vim.keymap.set("n", "<C-l>", "<C-w>l")
-- Ctrl+j: 切换到下面窗口
vim.keymap.set("n", "<C-j>", "<C-w>j")
-- Ctrl+k: 切换到上面窗口
vim.keymap.set("n", "<C-k>", "<C-w>k")

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

-- 切换自动换行
-- Alt+z: 切换行换行显示
vim.keymap.set("n", "<A-z>", "<CMD>set wrap!<CR>", { desc = "Toggle line wrap" })
