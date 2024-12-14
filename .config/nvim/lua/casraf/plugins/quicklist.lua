local function qf_remove()
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

--[[
  bufnr  buffer number; must be the number of a valid
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
  valid  recognized error message
]]

local function qf_add()
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

local function qf_clear()
  vim.fn.setqflist({}, "r")
  vim.cmd("cclose")
end

local qf_dir = vim.fn.stdpath("data") .. "/qf_dump"

local function get_qf_dump()
  local prj_root = vim.fn.finddir(".git/..", vim.fn.expand("%:p:h") .. ";")
  if prj_root == "" then
    prj_root = vim.fn.getcwd()
  end
  local prj_filename = prj_root:gsub("/", "_") .. ".lua"
  local file = qf_dir .. "/" .. prj_filename
  return file
end

local function create_qf_dir()
  local file = get_qf_dump()
  local dir = file:gsub("/[^/]*$", "")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end
end

local function qf_dump()
  local qfall = vim.fn.getqflist()
  create_qf_dir()
  local file = get_qf_dump()
  local f = io.open(file, "w+")
  if f == nil then
    vim.cmd("echo 'Quickfix file not found: " .. file .. "'")
    return
  end
  f:write("return " .. vim.inspect(qfall))
  f:close()
  vim.cmd("echo 'Quickfix dumped to " .. file .. "'")
end

local function qf_load()
  local file = get_qf_dump()
  local f = io.open(file, "r")
  if f == nil then
    vim.cmd("echo 'Quickfix file not found: " .. file .. "'")
    return
  end
  local qf = f:read("*all")
  f:close()
  local tbl = loadstring("return " .. qf)()
  vim.fn.setqflist(tbl, "r")
  vim.cmd("copen")
  vim.cmd("echo 'Quickfix loaded from " .. file .. "'")
end

vim.api.nvim_create_user_command("QFRemove", qf_remove, { force = true, desc = "Remove quickfix item" })
vim.api.nvim_create_user_command("QFAdd", qf_add, { force = true, desc = "Add to quickfix" })
vim.api.nvim_create_user_command("QFClear", qf_clear, { force = true, desc = "Clear quickfix" })
vim.api.nvim_create_user_command("QFDump", qf_dump, { force = true, desc = "Dump quickfix" })
vim.api.nvim_create_user_command("QFLoad", qf_load, { force = true, desc = "Load quickfix" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "dd", ":QFRemove<CR>", { buffer = true, desc = "Remove quickfix item" })
  end,
})

vim.keymap.set("n", "<leader>qq", "<Cmd>QFAdd<CR>", { desc = "Add to quickfix", silent = true })
vim.keymap.set("n", "<leader>qc", "<Cmd>QFClear<CR>", { desc = "Clear quickfix", silent = true })
vim.keymap.set("n", "<leader>Q", "<Cmd>copen<CR>", { desc = "Open quickfix", silent = true })
vim.keymap.set("n", "<M-j>", "<Cmd>cnext<CR>", { desc = "Next quickfix item", silent = true })
vim.keymap.set("n", "<M-k>", "<Cmd>cprev<CR>", { desc = "Previous quickfix item", silent = true })

return {}
