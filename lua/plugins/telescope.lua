local nvim  = require'nvim'
local tools = require'tools'

local executable  = require'tools'.files.executable
local load_module = require'tools'.helpers.load_module

local set_autocmd = nvim.autocmds.set_autocmd
local set_mapping = nvim.mappings.set_mapping
local set_command = nvim.commands.set_command

local telescope = load_module'telescope'

if not telescope then
    return false
end

-- local lsp_languages = require'plugins/lsp'
local ts_langs = require'plugins/treesitter'
local actions = require'telescope.actions'

telescope.setup{
    defaults = {
        vimgrep_arguments = tools.helpers.select_grep(false, 'grepprg', true),
        mappings = {
            i = {
                ["<ESC>"] = actions.close,
                -- ["<CR>"]  = actions.goto_file_selection_edit + actions.center,
            },
            n = {
                ["<ESC>"] = actions.close
            },
        },
        prompt_position = "bottom",
        prompt_prefix = ">",
        selection_strategy = "reset",
        sorting_strategy = "descending",
        layout_strategy = "horizontal",
        -- file_ignore_patterns = {},
        file_sorter =  require'telescope.sorters'.get_fzy_sorter ,
        generic_sorter =  require'telescope.sorters'.get_fzy_sorter,
        -- shorten_path = true,
        winblend = 0,
        -- width = 0.75,
        -- preview_cutoff = 120,
        -- results_height = 1,
        -- results_width = 0.8,
        -- border = {},
        -- borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
        -- color_devicons = true,
        -- use_less = true,
        set_env = { ['COLORTERM'] = 'truecolor' },

        -- file_previewer = require'telescope.previewers'.cat.new,
        -- grep_previewer = require'telescope.previewers'.vimgrep.new,
        -- qflist_previewer = require'telescope.previewers'.qflist.new,

        -- Developer configurations: Not meant for general override
        -- buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker

    },
}

-- *** Builtins ***
-- builtin.planets
-- builtin.builtin
-- builtin.find_files
-- builtin.git_files
-- builtin.buffers
-- builtin.oldfiles
-- builtin.commands
-- builtin.tags
-- builtin.command_history
-- builtin.help_tags
-- builtin.man_pages
-- builtin.marks
-- builtin.colorscheme
-- builtin.treesitter
-- builtin.live_grep
-- builtin.current_buffer_fuzzy_find
-- builtin.current_buffer_tags
-- builtin.grep_string
-- builtin.quickfix
-- builtin.loclist
-- builtin.reloader
-- builtin.vim_options
-- builtin.registers
-- builtin.keymaps
-- builtin.filetypes
-- builtin.highlights
-- builtin.git_commits
-- builtin.git_bcommits
-- builtin.git_branches
-- builtin.git_status

local noremap = {noremap = true}

set_command{
    lhs = 'LuaReloaded',
    rhs = [[lua require'telescope.builtin'.reloader()]],
    args = {force=true}
}

set_command{
    lhs = 'HelpTags',
    rhs = function()
        require'telescope.builtin'.help_tags{}
    end,
    args = {force=true}
}

set_mapping{
    mode = 'n',
    lhs = '<C-p>',
    rhs = function()
        local is_git = vim.b.project_root.is_git
        require'telescope.builtin'.find_files {
            find_command = tools.helpers.select_filelist(is_git, true)
        }
    end,
    args = {noremap = true}
}

set_mapping{
    mode = 'n',
    lhs = '<C-b>',
    rhs = [[<cmd>lua require'telescope.builtin'.buffers{}<CR>]],
    args = noremap,
}

set_mapping{
    mode = 'n',
    lhs = '<leader>g',
    rhs = [[<cmd>lua require'telescope.builtin'.live_grep{}<CR>]],
    args = noremap,
}

set_mapping{
    mode = 'n',
    lhs = '<C-q>',
    rhs = [[<cmd>lua require'telescope.builtin'.quickfix{}<CR>]],
    args = noremap,
}

set_command{
    lhs = 'Oldfiles',
    rhs = [[lua require'telescope.builtin'.oldfiles{}]],
    args = {force=true}
}

set_command{
    lhs = 'Registers',
    rhs = [[lua require'telescope.builtin'.registers{}]],
    args = {force=true}
}

set_command{
    lhs = 'Marks',
    rhs = [[lua require'telescope.builtin'.marks{}]],
    args = {force=true}
}

set_command{
    lhs = 'Manpages',
    rhs = [[lua require'telescope.builtin'.man_pages{}]],
    args = {force=true}
}

set_command{
    lhs = 'GetVimFiles',
    rhs = function()
        require'telescope.builtin'.find_files{
            cwd = require'sys'.base,
            find_command = tools.helpers.select_filelist(false, true)
        }
    end,
    args = {force=true}
}

if executable('git') then
    set_mapping{
        mode = 'n',
        lhs = '<leader>s',
        rhs = [[<cmd>lua require'telescope.builtin'.git_status{}<CR>]],
        args = noremap,
    }

    set_mapping{
        mode = 'n',
        lhs = '<leader>c',
        rhs = [[<cmd>lua require'telescope.builtin'.git_bcommits{}<CR>]],
        args = noremap,
    }

    set_mapping{
        mode = 'n',
        lhs = '<leader>C',
        rhs = [[<cmd>lua require'telescope.builtin'.git_commits{}<CR>]],
        args = noremap,
    }

    set_mapping{
        mode = 'n',
        lhs = '<leader>b',
        rhs = [[<cmd>lua require'telescope.builtin'.git_branches{}<CR>]],
        args = noremap,
    }
end

if ts_langs then
    set_autocmd{
        event   = 'FileType',
        pattern = ts_langs,
        cmd     = [[nnoremap <A-s> <cmd>lua require'telescope.builtin'.treesitter{}<CR>]],
        group   = 'TreesitterAutocmds'
    }
    set_autocmd{
        event   = 'FileType',
        pattern = ts_langs,
        cmd     = [[command! -buffer TSSymbols lua require'telescope.builtin'.treesitter{}]],
        group   = 'TreesitterAutocmds'
    }
end

return true
