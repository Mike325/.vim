local executable = require'utils.files'.executable

-- vim.opt_local.foldenable = true
-- vim.opt_local.foldmethod = 'syntax'

vim.opt_local.expandtab = true
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 0
vim.opt_local.softtabstop = -1

vim.opt_local.define = [[^\s*\<\(def\|class\)\>]]
vim.opt_local.suffixesadd:prepend('.py')
vim.opt_local.suffixesadd:prepend('__init__.py')

require'filetypes.python'.setup()

-- nnoremap <silent><buffer> <CR> :call mappings#cr()<CR>

-- if has#plugin('neomake')
--     call plugins#neomake#makeprg()
-- endif
