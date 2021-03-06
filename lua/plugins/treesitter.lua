local nvim        = require'nvim'
local load_module = require'tools'.helpers.load_module

local plugins = nvim.plugins
local set_autocmd = nvim.autocmds.set_autocmd
-- local set_command = nvim.commands.set_command
-- local set_mapping = nvim.mappings.set_mapping

local treesitter = load_module'nvim-treesitter.configs'

if treesitter == nil then
    return false
end

local ensure_installed = {
    'c',
    'cpp',
    'lua',
    'bash',
    'python',
    'latex',
    'jsonc',
    'toml',
    'query',
}

local disable = nil

if plugins.semshi ~= nil then
    disable = {'python'}
end

if plugins['vim-lsp-cxx-highlight'] ~= nil then
    disable = disable == nil and {'c', 'cpp'} or vim.list_extend(disable, {'c', 'cpp'})
end

local commet_txtobj = nil
if plugins['vim-textobj-comment'] == nil then
    commet_txtobj = '@comment.outer'
end

treesitter.setup{
    ensure_installed = ensure_installed,
    indent = {
        enable = true,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<A-i>",
            node_incremental = "<A-I>",
            scope_incremental = "<A-c>",
            node_decremental = "<A-D>",
        },
    },
    highlight = {
        enable = true,
        disable = disable,
    },
    textobjects = {
        swap = {
            enable = true,
            swap_next = {
                -- ["<leader>k"] = "@class.outer",
                -- ["<leader>c"] = "@comment.outer",
                -- ["<leader>f"] = "@loop.outer",
                ["<leader>f"] = "@conditional.outer",
                ["<leader>a"] = "@parameter.inner",
                ["<leader>m"] = "@function.outer",
            },
            swap_previous = {
                -- ["<leader><leader>k"] = "@class.outer",
                -- ["<leader><leader>c"] = "@comment.outer",
                -- ["<leader><leader>f"] = "@loop.outer",
                ["<leader><leader>f"] = "@conditional.outer",
                ["<leader><leader>a"] = "@parameter.inner",
                ["<leader><leader>m"] = "@function.outer",
            },
        },
        select = {
            enable = true,
            keymaps = {
                ["af"] = "@conditional.outer",
                ["if"] = "@conditional.inner",
                ["am"] = "@function.outer",    -- Same as [m, ]m "method"
                ["im"] = "@function.inner",
                ["ak"] = "@class.outer",
                ["ik"] = "@class.inner",
                ["ia"] = "@parameter.inner",
                ["aa"] = "@parameter.inner",
                ["ir"] = "@loop.inner",        -- "repeat" mnemonic
                ["ar"] = "@loop.outer",
                ["ac"] = commet_txtobj,
                ["ic"] = commet_txtobj,
            },
        },
        move = {
            enable = true,
            goto_next_start = {
                ["]f"] = "@conditional.outer",
                ["]m"] = "@function.outer",
                ["]]"] = "@class.outer",
                ["]r"] = "@loop.outer",
                ["]a"] = "@parameter.inner",
                ["]c"] = "@comment.outer",
            },
            goto_next_end = {
                ["]F"] = "@conditional.outer",
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
                ["]R"] = "@loop.outer",
                ["]A"] = "@parameter.inner",
                ["]C"] = "@comment.outer",
            },
            goto_previous_start = {
                ["[f"] = "@conditional.outer",
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer",
                ["[r"] = "@loop.outer",
                ["[a"] = "@parameter.inner",
                ["[c"] = "@comment.outer",
            },
            goto_previous_end = {
                ["[F"] = "@conditional.outer",
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
                ["[R"] = "@loop.outer",
                ["[A"] = "@parameter.inner",
                ["[C"] = "@comment.outer",
            },
        },
        -- lsp_interop = {
        --     enable = true,
        --     peek_definition_code = {
        --         ["df"] = "@function.outer",
        --         ["dF"] = "@class.outer",
        --     },
        -- },
    },
    playground = {
        enable = true,
        disable = {},
        updatetime = 25,
        persist_queries = false,
        keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
        },
    },
    query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = {"BufWrite", "CursorHold"},
    },
    refactor = {
        -- highlight_current_scope = { enable = true },
        smart_rename = {
            enable = true,
            keymaps = {
                smart_rename = "<A-r>",
            },
        },
        highlight_definitions = {
            enable = true,
            disable = disable,
        },
        navigation = {
            enable = true,
            keymaps = {
                goto_definition      = "<A-d>",
                list_definitions     = "<A-l>",
                goto_next_usage      = "<A-n>",
                goto_previous_usage  = "<A-N>",
                -- list_definitions_toc = "<A-t>",
            },
        },
    },
}

local parsers = require'nvim-treesitter.parsers'
local fts = {}

for lang,opts in pairs(parsers.list) do
    if parsers.has_parser(lang) then
        if opts.filetype ~= nil then
            lang = opts.filetype
        end
        fts[#fts + 1] = lang
        if opts.used_by ~= nil then
            vim.list_extend(fts, opts.used_by)
        end
    end
end

if #fts > 0 then
    -- TODO: Check module availability for each language
    set_autocmd{
        event   = 'FileType',
        pattern = fts,
        cmd     = 'setlocal foldmethod=expr foldexpr=nvim_treesitter#foldexpr()',
        group   = 'TreesitterAutocmds',
    }
end

-- Expose languages to VimL
nvim.g.ts_languages = fts

return fts
