-- disable netrw at the very start of your init.lua
-- 禁用内置的 netrw 文件管理器，以便使用插件式的文件管理器
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- 显示行号
vim.opt.number = true
-- 高亮当前行
vim.wo.cursorline = true
-- Display tabs and trailing spaces
-- 让制表符和尾部空格可见
vim.opt.list = true
vim.opt.listchars = { tab = ">-", trail = "-" }
-- 搜索时忽略大小写，除非搜索词包含大写字母
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- 高亮所有搜索匹配项
vim.opt.hlsearch = true

-- 滚动时保持光标上下各5行可见
vim.opt.scrolloff = 5
-- 水平滚动时保持光标左右各10列可见
vim.opt.sidescrolloff = 10
-- 防止滚动时光标跳到行首
vim.opt.startofline = false

-- 隐藏语法元素如 Markdown 链接（级别2）
vim.opt.conceallevel = 2

-- 始终显示1列宽的标记列，用于诊断/git标记
vim.o.signcolumn = "yes:1"

-- 禁用自动换行
vim.wo.wrap = false

-- Tab related options
-- 制表符相关选项
-- 每次按Tab键插入2个空格
vim.opt.softtabstop = 2
-- 每个缩进级别2个空格
vim.opt.shiftwidth = 2
-- 将制表符转换为空格
vim.opt.expandtab = true
-- 根据代码结构自动缩进
vim.opt.smartindent = true

-- 在当前窗口下方打开新分割窗口
vim.opt.splitbelow = true
-- 在当前窗口右侧打开新分割窗口
vim.opt.splitright = true

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
-- 在加载 lazy.nvim 之前设置领导者键，确保映射正确
-- 全局领导者键是空格键
vim.g.mapleader = " "
-- 本地领导者键是反斜杠
vim.g.maplocalleader = "\\"

-- 加载 lazy.nvim 插件管理器
require("config.lazy") -- Import `./lua/config/lazy.lua`

-- 加载自定义按键映射
require("keymapping")

-- Snacks profiler
-- Snacks 性能分析器
if vim.env.PROF then
	-- example for lazy.nvim
	-- change this to the correct path for your plugin manager
	-- 当设置 PROF 环境变量时，激活 snacks.nvim 性能分析器
	local snacks = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
	vim.opt.rtp:append(snacks)
	require("snacks.profiler").startup({
		startup = {
			event = "VimEnter", -- stop profiler on this event. Defaults to `VimEnter`
			-- event = "UIEnter",
			-- event = "VeryLazy",
		},
	})
end
