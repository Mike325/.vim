local nvim = require'nvim'
local executable =  require'utils.files'.executable

local set_command = require'nvim.commands'.set_command
local set_autocmd = require'nvim.autocmds'.set_autocmd
-- local set_mapping = require'nvim.mappings'.set_mapping

if vim.g.OSCTERM then
    vim.g.oscyank_term = vim.g.OSCTERM
elseif executable('kitty') then
    vim.g.oscyank_term = 'kitty'
elseif vim.g.OSCTERM then
    vim.g.oscyank_term = 'tmux'
else
    vim.g.oscyank_term = 'default'
end

set_command{
    lhs = 'OSCTerm',
    rhs = 'let g:oscyank_term = <q-args>',
    args = {force = true, nargs = 1, complete = 'customlist,neovim#vim_oscyank OSCTerm '}
}

set_autocmd{
    event = 'TextYankPost',
    pattern = '*',
    cmd = [[if v:event.operator is 'y' && (v:event.regname ==? '' || v:event.regname ==? '*' || v:event.regname ==? '+') |silent call YankOSC52(getreg(v:event.regname)) |endif]],
    group = 'OSCYank',
}