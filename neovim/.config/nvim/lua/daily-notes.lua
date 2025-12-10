--- *daily-notes.txt* Daily notes journaling system
--- *DailyNotes*
---
--- MIT License Copyright (c) 2024 mlwarner
---
--- ==============================================================================
---
--- A simple daily notes module for managing markdown journal entries.
--- Follows mini.nvim module structure and conventions.
---
--- Features:
--- - Open today's daily note
--- - Navigate to next/previous daily notes
--- - Open notes index file
--- - Integration with mini.pick for finding notes

---@diagnostic disable:undefined-global
local M = {}
local H = {}

--- Module setup
---
--- Default values:
---@eval return MiniDoc.afterlines_to_code(MiniDoc.current.eval_section)
---@text
--- # Default config~
---   {
---     -- Root directory for notes (supports '~' expansion)
---     root_dir = '~/Documents/my-notes/',
---     -- Subdirectory for daily journal entries
---     journal_dir = 'journal',
---   }
M.setup = function(config)
    -- Export module to global scope for easier usage
    _G.DailyNotes = M

    -- Setup config
    config = H.setup_config(config)

    -- Apply config
    H.apply_config(config)
end

--- Module config
M.config = {
    root_dir = '~/Documents/my-notes/',
    journal_dir = 'journal',
}

--- Open today's daily note
---
--- Creates a new daily note file with today's date (YYYY-MM-DD.md) or opens
--- an existing one. The file is created in the journal directory.
M.open_daily_note = function()
    local today = os.date('%Y-%m-%d')
    local note_path = H.get_daily_note_path(today)
    vim.cmd.edit(note_path)
end

--- Navigate to next daily note
---
--- If currently in a daily note, opens the note for the next day.
--- If not in a daily note, opens tomorrow's note.
--- Creates the file if it doesn't exist.
M.next_daily_note = function()
    local current_date = H.get_current_note_date()
    if not current_date then
        -- Not in a daily note, open tomorrow
        current_date = os.date('%Y-%m-%d')
    end

    local next_date = H.add_days(current_date, 1)
    local note_path = H.get_daily_note_path(next_date)
    vim.cmd.edit(note_path)
end

--- Navigate to previous daily note
---
--- If currently in a daily note, opens the note for the previous day.
--- If not in a daily note, opens yesterday's note.
--- Creates the file if it doesn't exist.
M.prev_daily_note = function()
    local current_date = H.get_current_note_date()
    if not current_date then
        -- Not in a daily note, open yesterday
        current_date = os.date('%Y-%m-%d')
    end

    local prev_date = H.add_days(current_date, -1)
    local note_path = H.get_daily_note_path(prev_date)
    vim.cmd.edit(note_path)
end

--- Open notes index file
---
--- Opens the index.md file at the root of the notes directory.
M.open_index = function()
    local index_path = vim.fs.joinpath(H.config.dir, 'index.md')
    vim.cmd.edit(index_path)
end

--- Get notes directory path
---
--- Returns the absolute path to the notes root directory.
--- Useful for integration with mini.pick or other tools.
---
---@return string Absolute path to notes directory
M.get_notes_dir = function()
    return H.config.dir
end

-- ┌─────────────────────────────────────────────────────────────────────────┐
-- │ Helper Functions                                                        │
-- └─────────────────────────────────────────────────────────────────────────┘

--- Setup configuration
H.setup_config = function(config)
    vim.validate('config', config, 'table', true)
    config = vim.tbl_deep_extend('force', vim.deepcopy(M.config), config or {})

    vim.validate('config.root_dir', config.root_dir, 'string')
    vim.validate('config.journal_dir', config.journal_dir, 'string')

    return config
end

--- Apply configuration
H.apply_config = function(config)
    H.config = {
        -- Expand '~' and normalize paths
        dir = vim.fs.normalize(config.root_dir),
    }
    H.config.journal_dir = vim.fs.joinpath(H.config.dir, config.journal_dir)
end

--- Get path for a daily note given a date string
---@param date string Date in YYYY-MM-DD format
---@return string Absolute path to the daily note file
H.get_daily_note_path = function(date)
    return vim.fs.joinpath(H.config.journal_dir, date .. '.md')
end

--- Extract date from current buffer's filename
---
--- Returns the date if the current buffer is a daily note (matches YYYY-MM-DD.md pattern),
--- otherwise returns nil.
---
---@return string|nil Date string in YYYY-MM-DD format, or nil if not a daily note
H.get_current_note_date = function()
    local bufname = vim.api.nvim_buf_get_name(0)
    if bufname == '' then
        return nil
    end

    -- Extract filename from path
    local filename = vim.fs.basename(bufname)

    -- Match YYYY-MM-DD.md pattern
    local date = filename:match('^(%d%d%d%d%-%d%d%-%d%d)%.md$')
    return date
end

--- Add or subtract days from a date string
---
--- Takes a date in YYYY-MM-DD format and adds/subtracts the specified number of days.
---
---@param date_str string Date in YYYY-MM-DD format
---@param days number Number of days to add (positive) or subtract (negative)
---@return string New date in YYYY-MM-DD format
H.add_days = function(date_str, days)
    -- Parse YYYY-MM-DD format
    local year, month, day = date_str:match('^(%d%d%d%d)%-(%d%d)%-(%d%d)$')
    if not year then
        error('Invalid date format: ' .. date_str .. '. Expected YYYY-MM-DD')
    end

    -- Convert to time (os.time expects local time at noon to avoid DST issues)
    local time = os.time({
        year = tonumber(year),
        month = tonumber(month),
        day = tonumber(day),
        hour = 12,
    })

    -- Add days (86400 seconds per day)
    local new_time = time + (days * 86400)

    -- Format back to YYYY-MM-DD
    return os.date('%Y-%m-%d', new_time)
end

return M
