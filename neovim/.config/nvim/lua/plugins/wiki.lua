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
        vim.keymap.set('n', '<leader>ni', open_wiki_index, { desc = 'Open [N]otes index' })
        vim.keymap.set('n', '<leader>nd', open_daily_journal, { desc = 'Open [N]otes [D]aily journal' })
        vim.keymap.set("n", "<leader>tt", ":lua require('toggle-checkbox').toggle()<CR>")
    end,
}
