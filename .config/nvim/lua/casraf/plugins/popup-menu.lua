local labels = {
  yank_word = "Yank\\ Word",
  yank_line = "Yank\\ Line",
  inspect = "Inspect",
  go_to_definition = "Go\\ To\\ Definition",
  go_to_references = "Go\\ To\\ References",
  back = "Back",
  open_url = "Open\\ URL",
}
vim.cmd(table.concat({
  'aunmenu PopUp',
  'anoremenu PopUp.' .. labels.yank_word .. '        yaw',
  'anoremenu PopUp.' .. labels.yank_line .. '        yy',
  'amenu PopUp.-Sep1-                                <NOP>',
  'anoremenu PopUp.' .. labels.inspect .. '          <cmd>Inspect<CR>',
  'amenu PopUp.-Sep2-                                <NOP>',
  'anoremenu PopUp.' .. labels.go_to_definition .. ' <cmd>lua vim.lsp.buf.definition()<CR>',
  'anoremenu PopUp.' .. labels.go_to_references .. ' <cmd>Telescope lsp_references<CR>',
  'amenu PopUp.-Sep3-                                <NOP>',
  'nnoremenu PopUp.' .. labels.back .. '             <C-t>',
  'nnoremenu PopUp.' .. labels.open_url .. '         gx',
}, '\n'))

local group = vim.api.nvim_create_augroup("nvim_popupmenu", { clear = true })

vim.api.nvim_create_autocmd("MenuPopup", {
  pattern = "*",
  group = group,
  desc = "Custom PopUp Setup",
  callback = function()
    vim.cmd(table.concat({
      'amenu disable PopUp.' .. labels.go_to_definition,
      'amenu disable PopUp.' .. labels.go_to_references,
      'nmenu disable PopUp.' .. labels.open_url
    }, '\n'))
    if #vim.lsp.get_clients({ bufnr = 0 }) then
      vim.cmd(table.concat({
        'amenu enable PopUp.' .. labels.go_to_definition,
        'amenu enable PopUp.' .. labels.go_to_references,
      }, '\n'))
    end
    local url = vim.fn.getline("."):match("http[^ ]+")
    if url then
      vim.cmd('nmenu enable PopUp.' .. labels.open_url)
    end
  end,
})

return {}
