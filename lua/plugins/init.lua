local nvim = require'nvim'
local echoerr = require'tools'.messages.echoerr

-- TODO: Add dynamic plugin load

if nvim.has('nvim-0.5') then
    local plugins = {
        iron       = { ok = false, status  = false},
        lsp        = { ok = false, status  = false},
        telescope  = { ok = false, status  = false},
        treesitter = { ok = false, status  = false},
        completion = { ok = false, status  = false},
    }

    for plugin, _ in pairs(plugins) do
        local ok, status = pcall(require, 'plugins/'..plugin)
        plugins[plugin].ok = ok
        plugins[plugin].status = status
        if not ok then
            echoerr(string.format('Failed to load %s, Error: %s', plugin, status))
            plugins[plugin].status = false
        end
    end

    if plugins.telescope.ok and not plugins.telescope.status then
        pcall(require, 'grep')
    end
end

local function get_plugins()
    return nvim.g.plugs
end

local plugins = get_plugins()

if plugins == nil then
    return nil
end

for plugin, _ in pairs(plugins) do
    require'tools'.helpers.load_settings(plugin)
end
