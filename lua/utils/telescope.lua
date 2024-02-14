local Util = require('utils')

---@class telescope.opts
---@field cwd? string|boolean
---@field show_untracked? boolean

---@class telescope
---@overload fun(builtin:string, opts?:telescope.opts)
local M = setmetatable({}, {
    __call = function(m, ...)
        return m.telescope(...)
    end,
})

---@param builtin string
---@param opts? telescope.opts
function M.telescope(builtin, opts)
    local params = { builtin = builtin, opts = opts }
    return function()
    builtin = params.builtin
    opts = params.opts
    opts = vim.tbl_deep_extend('force', { cwd = Util.listRoot() }, opts or {}) --[[@as telescope.opts]]
    if builtin == 'files' then
        if vim.uv.fs_stat((opts.cwd or vim.uv.cwd()) .. './.git') then
            opts.show_untracked = true
            builtin = 'git_files'
        else
            builtin = 'find_files'
        end
    end
    if opts.cwd and opts.cwd ~= vim.uv.cwd() then
        ---@diagnostic disable-next-line: inject-field
        opts.attach_mapping = function(_, map)
            map('i', '<a-c>', function()
                local action_state = require('telescope.actions.state')
                local line = action_state.get_current_line()
                M.telescope(
                    params.builtin,
                    vim.tbl_deep_extend('force', {}, params.opts or {}, { cwd = false, default_text = line })
                )()
            end)
            return true
        end
    end

    require('telescope.builtin')[builtin](opts)
end
end
function M.config_files()
  return Util.telescope("find_files", { cwd = vim.fn.stdpath("config") })
end

return M
