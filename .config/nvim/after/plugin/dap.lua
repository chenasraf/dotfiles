local dap = require("dap")

local path = os.getenv("HOME") .. "/.config/nvim/ext/js-debug"

dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "node",
    -- 💀 Make sure to update this path to point to your installation
    args = { path .. "/src/dapDebugServer.js", "${port}" },
  }
}

dap.configurations.javascript = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    cwd = "${workspaceFolder}",
  },
}

dap.configurations.typescript = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    cwd = "${workspaceFolder}",
  },
}

vim.keymap.set("n", "<leader>dc", "<cmd>lua require('dap').continue()<CR>",
  { noremap = true, silent = true, desc = "Debugger: Continue" })
vim.keymap.set("n", "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<CR>",
  { noremap = true, silent = true, desc = "Debugger: Toggle breakpoint" })
vim.keymap.set("n", "<leader>dr", "<cmd>lua require('dap').repl.open()<CR>",
  { noremap = true, silent = true, desc = "Debugger: Open REPL" })
vim.keymap.set("n", "<leader>dn", "<cmd>lua require('dap').step_over()<CR>",
  { noremap = true, silent = true, desc = "Debugger: Step over" })
vim.keymap.set("n", "<leader>di", "<cmd>lua require('dap').step_into()<CR>",
  { noremap = true, silent = true, desc = "Debugger: Step into" })
vim.keymap.set("n", "<leader>do", "<cmd>lua require('dap').step_out()<CR>",
  { noremap = true, silent = true, desc = "Debugger: Step out" })
vim.keymap.set("n", "<leader>dl", "<cmd>lua require('dap').run_last()<CR>",
  { noremap = true, silent = true, desc = "Debugger: Run last" })
vim.keymap.set("n", "<leader>dv", "<cmd>lua require('dap.ui.variables').visual_hover()<CR>",
  { noremap = true, silent = true, desc = "Debugger: Visual hover" })
vim.keymap.set("n", "<leader>dt", "<cmd>lua require('dap.ui.variables').hover()<CR>",
  { noremap = true, silent = true, desc = "Debugger: Hover" })
-- vim.keymap.set("n", "<leader>d1", 
-- TODO: clean up?
vim.keymap.set("n", "<leader>de", "<cmd>lua require('dap.ui.widgets').sidebar(require('dap.ui.widgets').scopes).open()<CR>",
  { noremap = true, silent = true, desc = "Debugger: Evaluate" })
