local sys = require'sys'

-- local is_dir     = require'tools'.files.is_dir
local executable = require'tools'.files.executable
local check_language_server = require'tools'.helpers.check_language_server

local has_python = require'python'.has_version

if executable('git') or vim.v.progname == 'vi' or vim.env['VIM_BARE'] then
    vim.g.bare = 1
elseif vim.env['VIM_MIN'] then
    vim.g.minimal = 1
end

vim.g.mapleader = ' '

-- Disable built-in plugins
vim.g.loaded_2html_plugin      = 1
vim.g.loaded_gzip              = 1
vim.g.loaded_rrhelper          = 1
vim.g.loaded_tarPlugin         = 1
vim.g.loaded_zipPlugin         = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_tarPlugin         = 1
vim.g.loaded_vimballPlugin     = 1

if sys.name == 'windows' then
    vim.o.shellslash = true
end

vim.g.plugs = {
    init = 1,
}

-- vim._update_package_paths()
require'python'.setup()
require'settings'

vim.cmd [[packadd! cfilter]]
vim.cmd [[packadd! matchit]]
-- vim.cmd [[packadd matchparen]]

-- Only required if you have packer in your `opt` pack
local packer_exists = pcall(vim.cmd, [[packadd packer.nvim]])
if not packer_exists then
    -- TODO: Maybe handle windows better?
    if vim.fn.input("Download Packer? (y for yes)") ~= "y" then
        return false
    end

    local directory = ('%s/site/pack/packer/opt/'):format(
        vim.fn.stdpath('data'):gsub('\\', '/')
    )

    vim.fn.mkdir(directory, 'p')

    print("Downloading packer.nvim...")
    local out = vim.fn.system(('git clone %s %s'):format(
        'https://github.com/wbthomason/packer.nvim',
        directory .. '/packer.nvim'
    ))

    print(out)

    return true
end

return require('packer').startup{function(use)
    use {'wbthomason/packer.nvim', opt = true}

    use {'tpope/vim-repeat'}
    use {'tpope/vim-apathy'}
    use {'tpope/vim-commentary'}

    use {
        'tweekmonster/startuptime.vim',
        -- cmd = {'StartupTime'},
    }

    use {
        'tpope/vim-surround',
        setup = function()
            require'tools'.helpers.load_settings'vim-surround'
        end,
    }

    use {
        'tpope/vim-projectionist',
        setup = function()
            require'tools'.helpers.load_settings'vim-projectionist'
        end,
    }

    use {
        'Raimondi/delimitMate',
        setup = function()
            require'tools'.helpers.load_settings'delimitMate'
        end,
    }

    use {
        'ojroques/vim-oscyank',
        config = function()
            require'tools'.helpers.load_settings'vim-oscyank'
        end,
    }

    use {'peterhoeg/vim-qml'}
    use {'PProvost/vim-ps1'}
    use {'cespare/vim-toml'}
    use {'bjoernd/vim-syntax-simics'}
    use {'kurayama/systemd-vim-syntax'}
    use {'mhinz/vim-nginx'}
    use {'raimon49/requirements.txt.vim'}

    use {'tpope/vim-abolish'}
    use {'honza/vim-snippets'}
    use {'tpope/vim-endwise'}
    -- use 'henrik/vim-indexed-search'
    -- use 'tpope/vim-markdown'

    use {
        'easymotion/vim-easymotion',
        config = function()
            require'tools'.helpers.load_settings'vim-easymotion'
        end,
    }

    use {
        'tommcdo/vim-lion',
        setup = function()
            vim.g.lion_squeeze_spaces = 1
        end,
    }

    use {
        'Yggdroot/indentLine',
        setup = function()
            require'tools'.helpers.load_settings'indentLine'
        end,
    }

    -- use {
    --     'moll/vim-bbye',
    --     cmd = {'Bdelete'},
    -- }

    use {
        'tpope/vim-dadbod',
        cmd = {'DB'}
    }

    use {
        'Vigemus/iron.nvim',
        cmd = {'IronFocus', 'IronRepl'},
        key = '=r',
        config = function()
            require'plugins.iron'
        end,
    }

    use {'kyazdani42/nvim-web-devicons'}
    use {
        'nvim-lua/telescope.nvim',
        config = function()
            require'plugins.telescope'
        end,
        requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
    }

    use {
        'nvim-lua/completion-nvim',
        event = 'InsertEnter *',
        config = function()
            require'plugins.completion'
        end,
    }

    if check_language_server() then
        use {
            'neovim/nvim-lspconfig',
            -- opt = true,
            config = function()
                require'plugins.lsp'
            end,
        }
    end

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require'plugins.treesitter'
        end,
        requires = {
            {'nvim-treesitter/nvim-treesitter-textobjects', after = 'nvim-treesitter'},
            {'nvim-treesitter/nvim-treesitter-refactor', after = 'nvim-treesitter'},
            {'nvim-treesitter/completion-treesitter', after = 'nvim-treesitter'},
        }
    }

    use {
        'ayu-theme/ayu-vim',
        event = 'ColorScheme *',
        setup = function()
            vim.g.ayucolor = 'dark'
        end,
        -- config = function()
        --     vim.cmd [[colorscheme ayu]]
        -- end,
    }

    use {
        'joshdick/onedark.vim',
        event = 'ColorScheme *',
        -- config = function()
        --     vim.cmd [[colorscheme onedark]]
        -- end,
    }

    use {
        'sainnhe/sonokai',
        -- event = 'ColorScheme *',
        setup = function()
            vim.g.airline_theme = 'sonokai'
            vim.g.sonokai_better_performance = 1
            vim.g.sonokai_style = 'shusia'
            vim.g.sonokai_enable_italic = 1
            vim.g.sonokai_disable_italic_comment = 1
            vim.g.sonokai_diagnostic_line_highlight = 1
        end,
        config = function()
            vim.cmd [[colorscheme sonokai]]
        end,
        after = 'vim-airline',
    }

    use {
        'vim-airline/vim-airline',
        setup = function()
            require'tools'.helpers.load_settings'vim-airline'
        end,
        requires = {{'vim-airline/vim-airline-themes', after = {'vim-airline'}}},
    }

    if executable('git') then

        use {
            'tpope/vim-fugitive',
            requires = 'tpope/vim-dispatch',
            config = function()
                require'tools'.helpers.load_settings'fugitive'
            end,
            event = 'VimEnter *',
        }

        use {
            'junegunn/gv.vim',
            cmd = {'GV'},
            after = 'vim-fugitive',
        }

        -- TODO: keep testing this
        -- use {
        --     'lambdalisue/gina.vim',
        -- }

        use {
            'rhysd/git-messenger.vim',
            config = function()
                require'tools'.helpers.load_settings'git-messenger.vim'
            end,
            key = '=m',
            cmd = {'GitMessenger'},
        }

        if sys.name ~= 'windows' then
            use { 'rhysd/committia.vim', }
        end

    end

    -- TODO: Load this if there's {parsers}.so files
    if executable('ccls') then
        use {
            'jackguo380/vim-lsp-cxx-highlight',
            ft = {'c', 'cpp', 'objc', 'objcpp', 'cuda'}
        }
    end

    -- Full load plugins
    use {
        'vimwiki/vimwiki',
        opt = true,
        ft = {'markdown', 'md', 'wiki'},
    }

    use {
        'lervag/vimtex',
        opt = true,
        ft = {'bib', 'tex'},
    }

    use {'kana/vim-textobj-user', event = 'VimEnter *'}
    use {'kana/vim-textobj-line', after = 'vim-textobj-user'}
    use {'kana/vim-textobj-entire', after = 'vim-textobj-user'}
    use {'michaeljsmith/vim-indent-object', after = 'vim-textobj-user'}
    use {
        'glts/vim-textobj-comment',
        after = 'vim-textobj-user',
        config = function()
            require'tools'.helpers.load_settings'vim-textobj-comment'
        end,
    }

    use {
        'mhinz/vim-signify',
        event = 'VimEnter *',
        config = function()
            require'tools'.helpers.load_settings'vim-signify'
        end,
    }

    if executable('firefox') or executable('chrome') then
        use {
            'glacambre/firenvim',
            run = ':call firenvim#install(0)',
            config = function()
                require'tools'.helpers.load_settings'firenvim'
            end,
        }
    end

    if has_python() then

        -- use {
        --     'neomake/neomake',
        --     opt = true,
        --     cmd = {'Neomake', 'NeomakeInfo'},
        --     config = function()
        --         require'tools'.helpers.load_settings'neomake'
        --     end,
        -- }

        if has_python(3, 5) then
            use {
                'SirVer/ultisnips',
                event = 'InsertEnter *',
                setup = function()
                    require'tools'.helpers.load_settings'ultisnips'
                end,
            }
            use {
                'numirias/semshi',
                run = ':silent! UpdateRemotePlugins',
                ft = {'python'},
                config = function()
                    require'tools'.helpers.load_settings'semshi'
                end,
            }
        else
            use {
                'SirVer/ultisnips',
                event = 'InsertEnter *',
                commit = '30e651f',
                lock = true,
                as = 'frozen-ultisnips',
                setup = function()
                    require'tools'.helpers.load_settings'ultisnips'
                end,
            }
        end

    end

end,}
