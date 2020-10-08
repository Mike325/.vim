local nvim = require'nvim'

local rename       = nvim.fn.rename
local bufloaded    = nvim.bufloaded
local executable   = nvim.executable
local isdirectory  = nvim.isdirectory
local filereadable = nvim.filereadable

local plugins      = require'nvim'.plugins

if tools.helpers == nil then
    tools.helpers = {}
end

function tools.helpers.rename(old, new, bang)

    new = new:gsub('\\', '/')
    old = old:gsub('\\', '/')

    if filereadable(new) or bang == 1 then

        if not filereadable(old) then
            nvim.ex.write(old)
        end

        if bufloaded(new) then
            nvim.ex['bwipeout!'](new)
        end

        if rename(old, new) == 0 then
            local cursor_pos = nvim.win.get_cursor(0)

            nvim.ex.edit(new)
            nvim.ex['bwipeout!'](old)

            nvim.win.set_cursor(0, cursor_pos)

            return true
        else
            nvim.echoerr('Failed to rename '..old)
        end
    elseif filereadable(new) then
        nvim.echoerr('File: '..new..' exists, use ! to override, it')
    end

    return false
end

function tools.helpers.delete(target, bang)
    target = target:gsub('\\', '/')
    if filereadable(target) or bufloaded(target) then
        if filereadable(target) then
            if nvim.fn.delete(target) == -1 then
                nvim.echoerr('Failed to delete the file: '..target)
            end
        end
        if bufloaded(target) then
            local command = bang == 1 and 'bwipeout! ' or 'bdelete! '
            local ok, error_code = pcall(nvim.command, command..target)
            if not ok and error_code:match('Vim(.%w+.)\\?:E94') then
                nvim.echoerr('Failed to remove buffer '..target)
            end
        end
    elseif isdirectory(target) then
        local flag = bang == 1 and 'rf' or 'd'
        if nvim.fn.delete(target, flag) == -1 then
            nvim.echoerr('Failed to remove the directory: '..target)
        end
    else
        nvim.echoerr('Non removable target: '..target)
    end
end

function tools.helpers.project_config(event)
    -- print(vim.inspect(event))

    local cwd = event.cwd or nvim.fn.getcwd()
    cwd = cwd:gsub('\\', '/')

    if nvim.b.project_root and nvim.b.project_root['cwd'] == cwd then
        return nvim.b.project_root
    end

    local root = tools.find_project_root(cwd)

    if #root == 0 then
        root = nvim.fn.fnamemodify(cwd, ':p')
    end

    root = root:gsub('\\', '/')

    if nvim.b.project_root and root == nvim.b.project_root['root'] then
        return nvim.b.project_root
    end

    local is_git = tools.is_git_repo(root)
    -- local filetype = nvim.bo.filetype
    -- local buftype = nvim.bo.buftype

    nvim.b.project_root = {
        cwd = cwd,
        file_dir = nvim.fn.expand('%:p:h'),
        root = root,
        is_git = is_git,
    }

    nvim.bo.grepprg = tools.select_grep(is_git)

    local project = nvim.fn.findfile('.project.vim', cwd..';')
    if #project > 0 then
        -- print('Sourcing Project ', project)
        nvim.ex.source(project)
    end

    local telescope = tools.load_module('telescope')

    if telescope ~= nil then
        nvim.nvim_set_mapping(
            'n',
            '<C-p>',
            [[<cmd>lua require'telescope.builtin'.find_files{ find_command = tools.to_clean_tbl(tools.select_filelist(require'nvim'.b.project_root.is_git))}<CR>]],
            {noremap = true}
        )
    end

    if plugins['ctrlp'] ~= nil then
        local fast_look_up = {
            ag = 1,
            fd = 1,
            rg = 1,
        }
        local fallback = nvim.g.ctrlp_user_command.fallback
        local clear_cache = is_git and 1 or (fast_look_up[fallback] ~= nil and 1 or 0)

        nvim.g.ctrlp_clear_cache_on_exit = clear_cache
    end

    if plugins['vim-grepper'] ~= nil then

        local operator = {}
        local tools = {}

        if executable('git') and is_git then
            tools[#tools + 1] = 'git'
            operator[#operator + 1] = 'git'
        end

        if executable('rg') then
            tools[#tools + 1] = 'rg'
            operator[#operator + 1] = 'rg'
        end

        if executable('ag') then
            tools[#tools + 1] = 'ag'
            operator[#operator + 1] = 'ag'
        end

        if executable('grep') then
            tools[#tools + 1] = 'grep'
            operator[#operator + 1] = 'grep'
        end

        if executable('findstr') then
            tools[#tools + 1] = 'findstr'
            operator[#operator + 1] = 'findstr'
        end

        nvim.g.grepper = {
            tools = tools,
            operator = {
                tools = operator
            },
        }

    end

    if plugins['gonvim-fuzzy'] ~= nil then
        nvim.g.gonvim_fuzzy_ag_cmd = tools.select_grep(is_git)
    end

end

return tools.helpers