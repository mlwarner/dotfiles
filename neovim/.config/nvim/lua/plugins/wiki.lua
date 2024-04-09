return {
    {
        'serenevoid/kiwi.nvim',
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        config = function()
            local sep = require("plenary.path").path.sep
            -- local wikiPath = '~/Documents/my_notes'
            -- local wikiPath = '/Users/mwarner/Library/CloudStorage/ProtonDrive-warnmat@proton.me/my_notes'
            -- local wikiPath = '~/vimwiki',
            -- local wikiPath = '/Users/mwarner/wiki'
            local wikiPath = '/Users/mwarner/Library/Mobile Documents/iCloud~md~obsidian/Documents/my_notes'
            -- local wikiPath = '/home/matt/wiki'
            local journalPath = wikiPath .. sep .. 'journal'

            require('kiwi').setup({
                {
                    name = 'personal',
                    path = wikiPath,
                },
                {
                    name = 'journal',
                    path = journalPath
                }
            })

            local kiwi = require('kiwi')

            local open_daily_journal = function()
                local isoDate = os.date("%Y-%m-%d")
                local filepath = journalPath .. sep .. isoDate .. ".md"
                local buffer_number = vim.fn.bufnr(filepath, true)
                vim.api.nvim_win_set_buf(0, buffer_number)
            end

            vim.keymap.set('n', '<leader>ww', function() kiwi.open_wiki_index() end, { desc = 'Open [W]iki index' })
            vim.keymap.set('n', '<leader>wp', function() kiwi.open_wiki_index('personal') end,
                { desc = 'Open [W]iki [P]ersonal' })
            vim.keymap.set('n', '<leader>wj', function() kiwi.open_wiki_index('journal') end,
                { desc = 'Open [W]iki [J]ournal' })
            vim.keymap.set('n', '<leader>wd', open_daily_journal, { desc = 'Open [W]iki [D]aily journal' })
            vim.keymap.set('n', '<leader>tt', kiwi.todo.toggle, { desc = '[T]oggle [T]ask' })

            vim.keymap.set('n', '<leader>wsf', function()
                require('mini.pick').builtin.files({}, { source = { cwd = wikiPath } })
            end, { desc = '[W]iki [S]earch [F]iles' })
            vim.keymap.set('n', '<leader>wsg', function()
                require('mini.pick').builtin.grep_live({}, { source = { cwd = wikiPath } })
            end, { desc = '[W]iki [S]earch by [G]rep' })

            -- vim.keymap.set('n', '<leader>wsf', function()
            --     require('telescope.builtin').find_files({ cwd = wikiPath })
            -- end, { desc = '[W]iki [S]earch [F]iles' })
            -- vim.keymap.set('n', '<leader>wsg', function()
            --     require('telescope.builtin').live_grep({ cwd = wikiPath })
            -- end, { desc = '[W]iki [S]earch by [G]rep' })
        end,
    }
}
