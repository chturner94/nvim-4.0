---@class util.terminal
---@overload fun(cmd: string, opts: ToggleTermOpts)
local M = setmetatable({}, {
    __call = function(m, ...)
        return m.open(...)
    end,
})

---@class Keybind
---@field mode string - Vim mode the keybind should operate within
---@field keystrokes string - Keystrokes for executing the command
---@field action string - The command or action you want to execute, i.e. `<cmd>ToggleTerm<cr>`
---@field description string - Description which can be registered in whichkey

---@class toggleKeybind
---@field keystrokes string - Keystroke for toggling the terminal
---@field description string - Description for whichkey

---@class ToggleTermOpts
---ignore cmd = string as we will take that inside the previous function
---@field direction? string - the layout for the terminal, same as the main config options
---@field hidden? boolean - determines if standard toggle method closes the terminal
---@field dir? string - the directory for the terminal
---@field close_on_exit? boolean - close the terminal window when the process exits
---@field highlights? table - a table with highlights
---@field env? table - key:value table with environmental variables pass to jobstart()
---@field clear_env? boolean - use only environmental variables from `env`, passed to jobstart()
---@field on_open? fun(t: Terminal) - function to run when the terminal opens
---@field on_close? fun(t: Terminal) - function to run when the terminal closes
---@field auto_scroll? boolean - automatically scroll to the bottom on terminal output
---callbacks for processing the output
---@field on_stdout? fun(t: Terminal, job: number, data: string[], name: string) - callback for processing output on stdout 
---@field on_stderr? fun(t: Terminal, job: number, data: string[], name: string) -- callback for processing output on stderr 
---@field on_exit? fun(t: Terminal, job: number, exit_code: number, name: string) -- function to run when terminal process exits
---@field toggleKeybind Keybind - Specified keybind for toggling this terminal
---@field keybinds? Keybind[]|Keybind - additional custom keybinds that can be assigned


---@type table<string,util.terminal>
local terminals = {}

--- Opens a floating terminal
--- @param cmd? string
--- @param opts? ToggleTermOpts
function M.open(cmd, opts)
---@module 'toggleterm'
    local Terminal = require('toggleterm').Terminal
    if (cmd == nil) then
        local index = #terminals
        local terminalName = 'custom' .. index
    else
    local terminalName = cmd:match('^%S+')
    end
    if terminals
end
