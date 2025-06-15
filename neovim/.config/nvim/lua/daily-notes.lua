local M = {}

local config = {}

M.setup = function(opts)
    opts = opts or {}

    vim.validate('opts', opts, 'table')
    vim.validate('opts.dir', opts.dir, 'string')

    -- Expand '~' character
    config.dir = vim.fs.normalize(opts.dir)
end

M.open_daily_note = function()
    local isoDate = os.date("%Y-%m-%d")
    local dailyNotePath = vim.fs.joinpath(config.dir, isoDate .. '.md')
    vim.cmd.edit(dailyNotePath)
end

M.next_daily_note = function()
    -- TODO: Implement
end

M.prev_daily_note = function()
    -- TODO: Implement
end

return M
