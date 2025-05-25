return {
    'saghen/blink.cmp',
    -- enabled = false,
    -- dev = true,
    dependencies = { 'rafamadriz/friendly-snippets', },
    version = '1.*',
    opts = {
        keymap = { preset = 'default' },

        completion = {
            -- Disable showing for all alphanumeric keywords by default. Prefer LSP specific trigger
            -- characters.
            -- trigger = { show_on_keyword = false },
            -- Controls whether the documentation window will automatically show when selecting a completion item
            documentation = { auto_show = true },
        },

        signature = { enabled = true },
    },
}
