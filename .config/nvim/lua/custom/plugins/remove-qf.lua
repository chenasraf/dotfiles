vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "dd", ":RemoveQFItem<CR>", { buffer = true, desc = "Remove quickfix item" })
  end,
})
vim.keymap.set("n", "<leader>q", ":AddToQF<CR>", { buffer = true, desc = "Add to quickfix" })

function RemoveQF()
  local curqfidx = vim.fn.line(".")
  local qfall = vim.fn.getqflist()
  table.remove(qfall, curqfidx)
  vim.fn.setqflist(qfall, "r")
  if vim.tbl_isempty(qfall) then
    vim.cmd("cclose")
    return
  end
  vim.cmd(tostring(curqfidx + 1) .. "cfirst")
  vim.cmd("copen")
end

--[[ bufnr  buffer number; must be the number of a valid
buffer
filename  name of a file; only used when "bufnr" is not
present or it is invalid.
module  name of a module; if given it will be used in
quickfix error window instead of the filename.
lnum  line number in the file
end_lnum  end of lines, if the item spans multiple lines
pattern  search pattern used to locate the error
col    column number
vcol  when non-zero: "col" is visual column
when zero: "col" is byte index
end_col  end column, if the item spans multiple columns
nr    error number
text  description of the error
type  single-character error type, 'E', 'W', etc.
valid  recognized error message ]]

function AddToQF()
  local bufnr = vim.fn.bufnr()
  local filename = vim.fn.expand("%:p")
  local module = vim.fn.expand("%:t")
  local lnum = vim.fn.line(".")
  local end_lnum = vim.fn.line(".")
  -- expand line
  local pattern = vim.fn.expand("<cword>")
  local col = vim.fn.col(".")
  local vcol = vim.fn.col(".")
  local end_col = vim.fn.col(".")
  local nr = 0
  -- whole line
  local text = vim.fn.getline(".")
  local type = "I"
  local valid = 1
  local item = {
    bufnr = bufnr,
    filename = filename,
    module = module,
    lnum = lnum,
    end_lnum = end_lnum,
    pattern = pattern,
    col = col,
    vcol = vcol,
    end_col = end_col,
    nr = nr,
    text = text,
    type = type,
    valid = valid,
  }
  local qfall = vim.fn.getqflist()
  table.insert(qfall, item)
  vim.fn.setqflist(qfall, "r")
  vim.cmd("copen")
end

function ClearQF()
  vim.fn.setqflist({}, "r")
  vim.cmd("cclose")
end

vim.api.nvim_create_user_command("RemoveQFItem", RemoveQF, { force = true })
vim.api.nvim_create_user_command("AddToQF", AddToQF, { force = true })
vim.api.nvim_create_user_command("ClearQF", ClearQF, { force = true })

return {}
