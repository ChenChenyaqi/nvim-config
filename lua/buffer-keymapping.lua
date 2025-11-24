-- 定义一个关闭所有 buffer 的函数
local function close_all_buffers()
  -- 获取所有 buffer 的列表
  local bufs = vim.api.nvim_list_bufs()
  for _, buf in ipairs(bufs) do
    -- 检查 buffer 是否有效且在列表中（避免关闭一些内部 buffer）
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
      require("snacks").bufdelete(buf)
    end
  end
end

-- 设置快捷键，例如 <leader>ba (Buffer All)
vim.keymap.set("n", "<leader>ba", close_all_buffers, { desc = "Close All Buffers" })

local function close_other_buffers()
  local current_buf = vim.api.nvim_get_current_buf()
  local bufs = vim.api.nvim_list_bufs()

  for _, buf in ipairs(bufs) do
    -- 只要不是当前 buffer，且是有效的 listed buffer，就关闭
    if buf ~= current_buf and vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
      require("snacks").bufdelete(buf)
    end
  end
end

-- 设置快捷键，例如 <leader>bo (Buffer Others)
vim.keymap.set("n", "<leader>bo", close_other_buffers, { desc = "Close Other Buffers" })
