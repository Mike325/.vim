local nvim = require'nvim'
local executable = require'tools'.files.executable

if not executable('git') then
    return false
end

local set_command = nvim.commands.set_command
-- local set_mapping = nvim.mappings.set_mapping
-- local get_mapping = nvim.mappings.get_mapping

local jobs = require'jobs'

local M = {}

function M.rm_commands()
    local git_cmds = {
        'GPush',
        'GPull',
        'GReview',
    }
    for _,cmd in pairs(git_cmds) do
        if nvim.has.cmd(cmd) then
            set_command { lhs = cmd }
        end
    end
end

function M.set_commands()
    set_command {
        lhs = 'GPull',
        rhs = function(args)
            local cmd = {'git'}
            if nvim.b.project_root and nvim.b.project_root.is_git then
                vim.list_extend(cmd, {'--git-dir', nvim.b.project_root.git_dir})
            end
            cmd[#cmd + 1] = 'pull'
            if args and args ~= '' then
                cmd[#cmd + 1] = args
            end
            jobs.send_job{
                cmd = cmd,
                save_data = true,
                opts = { pty = true, },
                qf = {
                    on_fail = {
                        open = true,
                        jump = false,
                    },
                    open = false,
                    jump = false,
                    efm = vim.bo.efm or vim.o.efm,
                    context = 'Git pull',
                    title = 'Git pull',
                },
            }

        end,
        args = {nargs = '*', force = true, buffer = true}
    }

    set_command {
        lhs = 'GPush',
        rhs = function(args)
            local cmd = {'git'}
            if nvim.b.project_root and nvim.b.project_root.is_git then
                vim.list_extend(cmd, {'--git-dir', nvim.b.project_root.git_dir})
            end
            cmd[#cmd + 1] = 'push'
            if args and args ~= '' then
                cmd[#cmd + 1] = args
            end
            jobs.send_job{
                cmd = cmd,
                save_data = true,
                opts = { pty = true, },
                qf = {
                    on_fail = {
                        open = true,
                        jump = false,
                    },
                    open = false,
                    jump = false,
                    efm = vim.bo.efm or vim.o.efm,
                    context = 'Git Push',
                    title = 'Git push',
                },
            }

        end,
        args = {nargs = '*', force = true, buffer = true}
    }

end

return M