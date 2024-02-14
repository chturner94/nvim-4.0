local M = {}

function M.initPlugins()
    local Plugin = require('lazy.core.plugin')
    local add = Plugin.Spec.add

    Plugin.Spec.add = function(self, plugin, ...)
        return add(self, plugin, ...)
    end
end

function M.initConfigs()
    local current_dir = vim.loop.cwd()
    local files = {}
    -- Iterate over files in the current directory
    for file in vim.fs.dir(current_dir) do
        if file ~= "." and file ~= ".." then
            local filename, extension = file:match("([^.]+)(%..+)$")
            if extension == ".lua" then
                local module_name = "configs." .. filename
                table.insert(files, "require('" .. module_name .. "')")
            end
        end
    end
    return table.concat(files, "\n")
end

function M.listRoot()
    return vim.cmd('LspZeroWorkspaceList')
end

---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
    local Config = require('config')
    print("Loading plugin:", name)

    if Config.plugins[name] and Config.plugins[name]._loaded then
        print("Plugin already loaded, calling callback")
        fn(name)
    else
        print("Setting up lazy loading for:", name)

        vim.api.nvim_create_autocmd("User", {
            callback = function()
                if name == event.data then
                    print("Lazy loading plugin:", name)
                    fn(name)
                    print("Removing autocmd for:", name)
                    return true
                end
            end,
        })
    end
end


return M
