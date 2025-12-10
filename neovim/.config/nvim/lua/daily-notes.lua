--- *daily-notes.txt* Daily notes journaling system
--- *DailyNotes*
---
--- A simple daily notes module for managing markdown journal entries.
--- Follows mini.nvim module structure and conventions.
---
--- Features:
--- - Open today's daily note
--- - Navigate to next/previous existing daily notes
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
--- Finds and opens the next existing daily note after the current date.
--- If currently in a daily note, navigates from that date.
--- If not in a daily note, navigates from today.
--- Does nothing if no future notes exist.
M.next_daily_note = function()
    local current_date = H.get_current_note_date()
    if not current_date then
        current_date = os.date('%Y-%m-%d')
    end

    local existing_dates = H.get_existing_note_dates()
    local next_date = H.find_next_date(existing_dates, current_date)

    if next_date then
        local note_path = H.get_daily_note_path(next_date)
        vim.cmd.edit(note_path)
    else
        vim.notify('No next daily note found', vim.log.levels.INFO)
    end
end

--- Navigate to previous daily note
---
--- Finds and opens the previous existing daily note before the current date.
--- If currently in a daily note, navigates from that date.
--- If not in a daily note, navigates from today.
--- Does nothing if no earlier notes exist.
M.prev_daily_note = function()
    local current_date = H.get_current_note_date()
    if not current_date then
        current_date = os.date('%Y-%m-%d')
    end

    local existing_dates = H.get_existing_note_dates()
    local prev_date = H.find_prev_date(existing_dates, current_date)

    if prev_date then
        local note_path = H.get_daily_note_path(prev_date)
        vim.cmd.edit(note_path)
    else
        vim.notify('No previous daily note found', vim.log.levels.INFO)
    end
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

--- Get all existing daily note dates
---
--- Scans the journal directory for daily note files and extracts their dates.
---
---@return table List of date strings in YYYY-MM-DD format, sorted ascending
H.get_existing_note_dates = function()
    local dates = {}
    local journal_path = H.config.journal_dir

    -- Check if journal directory exists
    local stat = vim.uv.fs_stat(journal_path)
    if not stat or stat.type ~= 'directory' then
        return dates
    end

    -- Scan directory for .md files
    local handle = vim.uv.fs_scandir(journal_path)
    if not handle then
        return dates
    end

    while true do
        local name, type = vim.uv.fs_scandir_next(handle)
        if not name then
            break
        end

        -- Match YYYY-MM-DD.md pattern
        if type == 'file' then
            local date = name:match('^(%d%d%d%d%-%d%d%-%d%d)%.md$')
            if date then
                table.insert(dates, date)
            end
        end
    end

    -- Sort dates in ascending order
    table.sort(dates)

    return dates
end

--- Find next date after current date
---
---@param dates table List of date strings, sorted ascending
---@param current_date string Current date in YYYY-MM-DD format
---@return string|nil Next date or nil if none found
H.find_next_date = function(dates, current_date)
    for _, date in ipairs(dates) do
        if date > current_date then
            return date
        end
    end
    return nil
end

--- Find previous date before current date
---
---@param dates table List of date strings, sorted ascending
---@param current_date string Current date in YYYY-MM-DD format
---@return string|nil Previous date or nil if none found
H.find_prev_date = function(dates, current_date)
    local prev = nil
    for _, date in ipairs(dates) do
        if date >= current_date then
            break
        end
        prev = date
    end
    return prev
end

return M
