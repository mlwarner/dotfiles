local M = {}

local config = {}

M.setup = function(opts)
    opts = opts or {}

    vim.validate('opts', opts, 'table')
    vim.validate('opts.root_dir', opts.root_dir, 'string')
    vim.validate('opts.journal_dir', opts.journal_dir, 'string')

    -- Expand '~' character
    config.dir = vim.fs.normalize(opts.root_dir)
    config.journal_dir = vim.fs.joinpath(config.dir, opts.journal_dir)
end

M.open_daily_note = function()
    local isoDate = os.date("%Y-%m-%d")
    local dailyNotePath = vim.fs.joinpath(config.journal_dir, isoDate .. '.md')
    vim.cmd.edit(dailyNotePath)
end

M.open_index = function()
    vim.cmd.edit(vim.fs.joinpath(config.dir, 'index.md'))
end

M.get_notes_dir = function()
    return config.dir
end

return M
