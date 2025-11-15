# CLAUDE.md - AI Assistant Guide for mlwarner/dotfiles

This document provides comprehensive guidance for AI assistants (Claude, etc.) working with this dotfiles repository.

## Repository Overview

This is a **GNU Stow-based dotfiles repository** managing personal configuration files across multiple development tools and environments. The repository uses a modular, tool-specific structure where each tool has its own directory that mirrors the home directory layout.

**Key Facts:**
- Primary workflow: GNU Stow for symlinking configurations
- Target platforms: macOS and Linux (dual support)
- Philosophy: Modular, tool-specific configurations with consistent themes and keybindings
- Main editor: Neovim with mini.nvim ecosystem
- Theme consistency: Gruvbox and Kanagawa across tools
- Keybinding philosophy: Vim-style hjkl navigation everywhere

## Repository Structure

```
dotfiles/
├── .editorconfig              # Global editor standards (UTF-8, LF, 4 spaces, 120 chars)
├── .gitignore                 # Excludes lbdb/ directory
├── README.md                  # User-facing setup instructions
├── CLAUDE.md                  # This file - AI assistant guide
│
├── ghostty/                   # Ghostty terminal emulator
├── git/                       # Git configuration and global ignore
├── neovim/                    # Neovim editor (most complex config)
└── vscode/                    # VS Code settings (Vim mode)
```

### GNU Stow Pattern

Each tool directory follows this structure:
```
{tool-name}/
└── .config/                   # Linux/XDG path
    └── {tool-name}/           # Actual config files
OR
└── Library/                   # macOS path
    └── Application Support/   # macOS-specific location
```

When `stow {tool-name}` is run, it creates symlinks:
- `~/dotfiles/neovim/.config/nvim/` → `~/.config/nvim/`
- `~/dotfiles/git/.config/git/` → `~/.config/git/`

## Key Directories Deep Dive

### neovim/ - The Heart of the Configuration

**Location:** `neovim/.config/nvim/`

**Philosophy:** Mini.nvim-first configuration following MiniMax structure with semantic leader key groups.

**Critical Files:**
- `init.lua` - Entry point, bootstraps mini.nvim, defines global helpers
- `plugin/10_options.lua` - Neovim options (numbered for load order)
- `plugin/20_keymaps.lua` - All keybindings with leader groups
- `plugin/30_mini.lua` - Mini.nvim module configurations
- `plugin/40_plugins.lua` - Non-mini plugins (treesitter, LSP, completion)

**Loading Order:** Files in `plugin/` are numbered (10_, 20_, 30_, 40_) to control load sequence.

**Leader Key System:** Two-key approach with semantic grouping:
- `<Space>` is Leader key
- First key = semantic group, second key = action
- Groups: `b`(Buffer), `e`(Explore/Edit), `f`(Find), `g`(Git), `l`(Language/LSP), `n`(Notes), `o`(Other), `s`(Session), `t`(Terminal), `v`(Visits)

**Important Patterns:**
```lua
-- Global config table for sharing data between scripts
_G.Config = {}

-- Lazy loading helpers from mini.deps
MiniDeps.now()    -- Load immediately
MiniDeps.later()  -- Load after startup
Config.now_if_args -- Load now only if files passed as args

-- Custom autocmd helper
Config.new_autocmd(event, pattern, callback, desc)

-- Leader group clues (for mini.clue)
_G.Config.leader_group_clues = { ... }
```

**Custom Modules:**
- `lua/daily-notes.lua` - Daily journaling system (~/Documents/my-notes/)
- `lua/debug.lua` - Debugging utilities

**Override System:**
- `after/ftplugin/` - Filetype-specific settings (markdown, gitcommit, etc.)
- `after/lsp/` - LSP server configurations (harper_ls, lua_ls, vtsls)

**Key Keybindings to Remember:**
- `<C-p>` - Quick file picker (no leader needed)
- `<C-f>` - Quick grep live (no leader needed)
- `<Space>ed` - File explorer at cwd
- `<Space>ef` - File explorer at current file
- `<Space>ff` - Find files
- `<Space>fg` - Live grep
- `<Space>nd` - Open daily note
- `grn` - LSP rename (overrides built-in for mini.operators compatibility)
- `gra` - LSP code actions

### git/ - Version Control

**Location:** `git/.config/git/`

**Files:**
- `config` - Git aliases (br, ci, co, st, sw, df)
- `ignore` - Global gitignore patterns (includes `.claude/settings.local.json`)

**Important:** All `.claude/settings.local.json` files are globally ignored.

### ghostty/ - Terminal Emulator

**Location:** `ghostty/.config/ghostty/config`

**Purpose:** Modern terminal emulator

**Features:**
- Theme: Kanagawa Dragon
- Font size: 16, thickening enabled
- Quick terminal toggle support

### vscode/ - Visual Studio Code

**Location:** `vscode/Library/Application Support/Code/User/`

**Settings:**
- Vim mode enabled
- JetBrains Mono font
- Relative line numbers
- Gruvbox theme

## Development Workflows

### Making Changes to Configurations

1. **Edit files in the dotfiles repo:**
   ```bash
   cd ~/dotfiles/neovim/.config/nvim
   nvim plugin/20_keymaps.lua
   ```

2. **Changes take effect immediately** (configs are symlinked)

3. **For Neovim changes:** Restart Neovim or use `:source $MYVIMRC`

4. **Commit changes with descriptive messages:**
   ```bash
   git add .
   git commit -m "feat(nvim): Add new keybinding for XYZ"
   ```

### Adding New Tool Configurations

1. **Create tool directory with proper structure:**
   ```bash
   mkdir -p newtool/.config/newtool
   ```

2. **Add configuration files:**
   ```bash
   cp /path/to/config newtool/.config/newtool/
   ```

3. **Stow the new configuration:**
   ```bash
   stow newtool
   ```

### Commit Message Convention

Based on recent history, follow this pattern:
- `feat(tool): Description` - New features
- `chore(tool): Description` - Maintenance, formatting
- `fix(tool): Description` - Bug fixes

Examples from recent commits:
- `feat(nvim): Change more keymappings to match minimax`
- `feat(nvim): Add mini.bracketed and mini.bufremove modules`
- `chore: formatting`

## Code Standards and Conventions

### EditorConfig Standards (.editorconfig)

ALL files should follow:
- **Encoding:** UTF-8
- **Line endings:** LF (Unix-style)
- **Indentation:** 4 spaces (not tabs)
- **Line length:** 120 characters max
- **Final newline:** Required
- **Trailing whitespace:** Trimmed

### Neovim Lua Conventions

1. **File Organization:**
   - Use numbered prefixes for load order in `plugin/`
   - Group related functionality together
   - Document with section headers using ASCII art borders

2. **Code Style:**
   ```lua
   -- Section headers
   -- ┌─────────────────┐
   -- │ Section Name    │
   -- └─────────────────┘

   -- Helper function patterns
   local helper_name = function(arg)
       -- Implementation
   end

   -- Keymapping helpers
   local nmap_leader = function(suffix, rhs, desc)
       vim.keymap.set('n', '<Leader>' .. suffix, rhs, { desc = desc })
   end
   ```

3. **Documentation:**
   - Add descriptive comments explaining WHY, not WHAT
   - Reference help tags: `:h topic-name`
   - Document key mappings with descriptions

4. **Leader Mappings:**
   - Always use semantic two-key approach
   - Add to `Config.leader_group_clues` for new groups
   - Prefer mnemonic key choices

### Git Configuration

- **Branch naming:** Recent AI-assisted work uses `claude/` prefix with session IDs
- **Ignored patterns:** `.claude/settings.local.json` globally ignored
- **Aliases available:** br, ci, co, st, sw, df

## Important Files Reference

| File Path | Purpose | When to Edit |
|-----------|---------|--------------|
| `neovim/.config/nvim/init.lua` | Neovim entry point, bootstraps mini.nvim | Rarely, only for bootstrap logic |
| `neovim/.config/nvim/plugin/10_options.lua` | Vim options and settings | When changing editor behavior |
| `neovim/.config/nvim/plugin/20_keymaps.lua` | All keybindings | When adding/modifying shortcuts |
| `neovim/.config/nvim/plugin/30_mini.lua` | Mini.nvim module setup | When configuring mini modules |
| `neovim/.config/nvim/plugin/40_plugins.lua` | Non-mini plugins | When adding new plugins |
| `neovim/.config/nvim/lua/daily-notes.lua` | Daily notes system | When modifying journaling workflow |
| `git/.config/git/config` | Git aliases | When adding git shortcuts |
| `git/.config/git/ignore` | Global gitignore | When adding global ignore patterns |
| `.editorconfig` | Global editor standards | Rarely, affects all files |

## Special Considerations for AI Assistants

### When Working with Neovim Configuration

1. **Respect the Loading Order:**
   - Files prefixed with numbers (10_, 20_, etc.) have intentional load order
   - Don't renumber files without good reason
   - Add new plugin files with appropriate number prefix

2. **Leader Key System:**
   - Always document new leader mappings with semantic groups
   - Update `Config.leader_group_clues` when creating new groups
   - Use the two-key approach consistently

3. **Mini.nvim First:**
   - Prefer mini.nvim modules over external plugins when possible
   - This config is designed around mini.nvim ecosystem
   - Check if mini.nvim has a module before adding external plugin

4. **Lazy Loading:**
   - Use `MiniDeps.later()` for non-critical plugins
   - Use `MiniDeps.now()` only when needed at startup
   - Use `Config.now_if_args` for file-opening-specific plugins

5. **Documentation:**
   - Add comments explaining the reasoning behind changes
   - Reference Neovim help tags (`:h topic`) in comments
   - Update config header comments when adding new files

### When Making Repository Changes

1. **Preserve Stow Structure:**
   - Never move files out of `.config/` or `Library/` subdirectories
   - Maintain the mirror structure that Stow expects

2. **Cross-Platform Compatibility:**
   - Consider both macOS and Linux when making changes
   - Test paths work on both platforms when possible
   - Document platform-specific changes

3. **Commit Guidelines:**
   - Use conventional commit format: `type(scope): description`
   - Types: feat, fix, chore, docs
   - Scopes: nvim, git, ghostty, vscode, or tool name
   - Keep commits focused and atomic

4. **Testing Changes:**
   - Test Neovim changes before committing
   - For Stow changes, verify symlinks are created correctly
   - Check that removed files don't break existing configs

### Understanding User Preferences

Based on the configuration, the user:
- **Strongly prefers Vim keybindings** - Present in every tool
- **Values consistency** - Same themes, fonts, and navigation across tools
- **Uses modal editing heavily** - Neovim, Vim mode in VS Code
- **Organizes with semantic meaning** - Leader key groups with semantic two-key approach
- **Works with notes/journaling** - Custom daily notes system
- **Uses AI assistance** - CodeCompanion plugin for AI in Neovim

### Common Tasks Guide

**Adding a new Neovim plugin:**
1. Edit `plugin/40_plugins.lua` (or `plugin/30_mini.lua` for mini modules)
2. Use `MiniDeps.add()` with appropriate `now()` or `later()` wrapper
3. Configure in the same file or create dedicated file
4. Update keymaps in `plugin/20_keymaps.lua` if needed
5. Add to `Config.leader_group_clues` if creating new group

**Adding a new leader mapping:**
1. Edit `plugin/20_keymaps.lua`
2. Choose semantic group (or create new one)
3. Use `nmap_leader()` or `xmap_leader()` helper
4. If new group, add to `Config.leader_group_clues`
5. Document with clear description

**Adding a new tool configuration:**
1. Create `toolname/.config/toolname/` directory
2. Add configuration files
3. Update this CLAUDE.md with new tool section
4. Update README.md if it affects setup
5. Run `stow toolname` to test

**Updating dependencies:**
- Neovim plugins: Use `:DepsUpdate` command
- System packages: Use Homebrew as documented in README

## Quick Reference

### Most Frequently Modified Files
1. `neovim/.config/nvim/plugin/20_keymaps.lua` - Keybindings
2. `neovim/.config/nvim/plugin/40_plugins.lua` - Plugin additions
3. `neovim/.config/nvim/plugin/30_mini.lua` - Mini.nvim configs
4. `git/.config/git/config` - Git aliases

### Key Navigation Shortcuts (Neovim)
- Files: `<C-p>` or `<Space>ff`
- Grep: `<C-f>` or `<Space>fg`
- Buffers: `<Space>,` or `<Space>fb`
- Explorer: `<Space>ed` (cwd) or `<Space>ef` (current file)
- Git: `<Space>g` prefix
- LSP: `<Space>l` prefix or `gr` prefix (grn=rename, gra=actions)
- Daily note: `<Space>nd`

### Useful Commands
- Update Neovim plugins: `:DepsUpdate`
- Show mini.pick help: `:h MiniPick`
- Show keybindings: `:h` on any keymap in config
- Daily notes: `<Space>nd` (today), `<Space>ni` (index)

## Troubleshooting

### Common Issues

**Symlinks not working:**
- Ensure you're in `~/dotfiles` directory
- Run `stow -R {tool}` to restow
- Check for conflicting files in `~/.config/`

**Neovim errors on startup:**
- Check `init.lua` for syntax errors
- Verify mini.nvim is bootstrapped: `:echo stdpath('data')`
- Run `:DepsUpdate` to update plugins
- Check numbered files are in correct order

**Git ignoring .claude files:**
- This is intentional - see `git/.config/git/ignore`
- `.claude/settings.local.json` should not be committed

## Version Information

- **Last Updated:** 2025-11-15
- **Recent Changes:** MiniMax-style organization, updated keymaps, mini.bracketed and mini.bufremove additions
- **Neovim Config Style:** MiniMax-inspired with mini.nvim ecosystem
- **Primary Maintainer:** mlwarner

---

**For AI Assistants:** When in doubt, prioritize:
1. Maintaining consistency with existing patterns
2. Following the mini.nvim ecosystem approach
3. Preserving the semantic leader key organization
4. Respecting the GNU Stow directory structure
5. Testing changes before committing
