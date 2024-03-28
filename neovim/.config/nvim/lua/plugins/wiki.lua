return {
    {
        'serenevoid/kiwi.nvim',
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        config = function()
            local sep = require("plenary.path").path.sep
            -- require('kiwi').setup({
            --     {
            --         name = 'personal',
            --         path = '/home/matt/vimwiki',
            --         -- path = '~/Documents/my_notes'
            --         -- path = '/Users/mwarner/Library/Mobile Documents/iCloud~md~obsidian/Documents/my_notes'
            --         -- path = '/Users/mwarner/Library/CloudStorage/ProtonDrive-warnmat@proton.me/my_notes'
            --         -- path = '~/vimwiki',
            --     }
            -- })

            local kiwi = require('kiwi')

            local open_daily_journal = function ()
                local isoDate = os.date("%Y-%m-%d")
                local filepath = kiwi.utils.get_wiki_path() .. sep .. "journal" .. sep .. isoDate .. ".md"
                local buffer_number = vim.fn.bufnr(filepath, true)
                vim.api.nvim_win_set_buf(0, buffer_number)
            end

            vim.keymap.set('n', '<leader>ww', kiwi.open_wiki_index, {})
            vim.keymap.set('n', '<leader>wd', open_daily_journal, {})
            vim.keymap.set('n', '<leader>tt', kiwi.todo.toggle, { desc = '[T]oggle [T]ask'})

            vim.keymap.set('n', '<leader>wf', function()
                require('telescope.builtin').find_files({ cwd = kiwi.utils.get_wiki_path() })
            end, { desc = '[W]iki [F]iles' })
            vim.keymap.set('n', '<leader>wg', function()
                require('telescope.builtin').live_grep({ cwd = kiwi.utils.get_wiki_path() })
            end, { desc = '[W]iki [G]rep' })
        end,
    }
}
