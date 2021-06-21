local nvim  = require'nvim'
local load_module = require'utils.helpers'.load_module

local set_mapping = require'nvim.mappings'.set_mapping

local hop = load_module'hop'

if not hop then
    return false
end

hop.setup{}

set_mapping{
    mode = 'n',
    lhs = [[\]],
    rhs = "<cmd>lua require'hop'.hint_char1()<CR>",
    args = {noremap = true},
}

return true