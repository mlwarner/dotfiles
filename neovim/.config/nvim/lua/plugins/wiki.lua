return {
    'opdavies/toggle-checkbox.nvim',
    config = function()
        local wikiPath = vim.fs.normalize('~/Documents/my-notes')

        local open_wiki_index = function()
            local wikiIndexPath = vim.fs.joinpath(wikiPath, 'index.md')
            vim.cmd.edit(wikiIndexPath)
        end

        local open_daily_journal = function()
            local journalPath = vim.fs.joinpath(wikiPath, 'journal')
            local isoDate = os.date("%Y-%m-%d")
            local dailyJournalPath = vim.fs.joinpath(journalPath, isoDate .. '.md')
            vim.cmd.edit(dailyJournalPath)
        end

        vim.keymap.set('n', '<leader>ww', open_wiki_index, { desc = 'Open [W]iki index' })
        vim.keymap.set('n', '<leader>wd', open_daily_journal, { desc = 'Open [W]iki [D]aily journal' })
        vim.keymap.set("n", "<leader>tt", ":lua require('toggle-checkbox').toggle()<CR>")

        -- vim.keymap.set('n', '<leader>wsf', function()
        --     require('mini.pick').builtin.files({}, { source = { cwd = wikiPath } })
        -- end, { desc = '[W]iki [S]earch [F]iles' })
        -- vim.keymap.set('n', '<leader>wsg', function()
        --     require('mini.pick').builtin.grep_live({}, { source = { cwd = wikiPath } })
        -- end, { desc = '[W]iki [S]earch by [G]rep' })
        vim.keymap.set('n', '<leader>wsf', function() Snacks.picker.files({ cwd = wikiPath }) end,
            { desc = '[W]iki [S]earch [F]iles' })
        vim.keymap.set('n', '<leader>wsg', function() Snacks.picker.grep({ cwd = wikiPath }) end,
            { desc = '[W]iki [S]earch by [G]rep' })
    end,
}
