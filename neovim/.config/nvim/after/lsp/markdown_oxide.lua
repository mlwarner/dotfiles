-- markdown-oxide re-indexes the vault when files change on disk (new daily
-- notes, renames). It needs the client to allow dynamic file-watch registration,
-- which Neovim turns off by default on Linux. This deep-merges with the
-- capabilities blink.cmp sets on '*'. See `:h vim.lsp.config()`.
--
-- Vault settings (daily notes folder/format, etc.) live in `.moxide.toml` at
-- the notes root, which is also what marks the vault root for lspconfig.
return {
    capabilities = {
        workspace = {
            didChangeWatchedFiles = { dynamicRegistration = true },
        },
    },
}
