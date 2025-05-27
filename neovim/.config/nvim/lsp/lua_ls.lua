return {
    settings = {
        Lua = {
            telemetry = { enable = false },
            -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            diagnostics = { disable = { 'missing-fields' } },
            hint = { enable = true },
        },
    }
}
