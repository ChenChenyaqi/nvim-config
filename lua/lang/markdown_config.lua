local M = {}

M.get_markdown_formatting_config = function()
  return {
    markdown = { "prettierd" },
    ["markdown.mdx"] = { "prettierd" },
  }
end

return M
