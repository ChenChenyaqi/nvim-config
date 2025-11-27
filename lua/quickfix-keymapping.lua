-- 切换Quickfix list
vim.keymap.set("n", "<leader>q", function()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win["quickfix"] == 1 then
      qf_exists = true
    end
  end
  if qf_exists then
    vim.cmd("cclose")
  else
    vim.cmd("copen")
  end
end, { desc = "Toggle Quickfix List" })

-- 当 FileType 为 qf (Quickfix) 时，自动创建键位映射
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    local opts = { buffer = true, silent = true, desc = "Delete item from qflist" }

    vim.api.nvim_win_set_height(0, 15)

    -- 绑定 'dd' 删除当前行
    vim.keymap.set("n", "dd", function()
      local list = vim.fn.getqflist() -- 获取当前列表
      local lnum = vim.fn.line(".") -- 获取当前光标行号

      -- 如果列表为空，直接返回
      if #list == 0 then
        return
      end

      -- 从表中移除对应行
      table.remove(list, lnum)

      -- 将修改后的列表重新设置回去 ('r' 表示 replace/替换)
      vim.fn.setqflist(list, "r")

      -- 恢复光标位置（因为重置列表后光标可能会跑）
      if lnum > #list then
        lnum = #list
      end
      vim.api.nvim_win_set_cursor(0, { lnum, 0 })

      print("Item deleted")
    end, opts)

    -- (可选) 绑定 visual 模式下的 'd' 删除多行
    vim.keymap.set("v", "d", function()
      local list = vim.fn.getqflist()
      -- 获取选区的起始和结束行
      local vstart = vim.fn.line("v")
      local vend = vim.fn.line(".")
      if vstart > vend then
        vstart, vend = vend, vstart
      end -- 确保 start < end

      -- 从后往前删，避免索引错位
      for i = vend, vstart, -1 do
        table.remove(list, i)
      end

      vim.fn.setqflist(list, "r")

      -- 退出 Visual 模式
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)

      -- 恢复光标
      if vstart > #list then
        vstart = #list
      end
      if vstart > 0 then
        vim.api.nvim_win_set_cursor(0, { vstart, 0 })
      end
    end, opts)
  end,
})
