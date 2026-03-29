# Repository Guidelines

## Project Structure & Module Organization
This repository is a modular Neovim configuration written in Lua. `init.lua` is the entry point and sets editor defaults, leaders, and bootstrap logic. `lua/config/lazy.lua` configures `lazy.nvim` and loads plugin specs from `lua/plugins/`. Keep plugin definitions grouped by concern in `lua/plugins/` (for example `lsp.lua`, `ui.lua`, `completion.lua`). Put language-specific setup in `lua/lang/`, and keep reusable mappings in focused files such as `lua/keymapping.lua`, `lua/buffer-keymapping.lua`, and `lua/quickfix-keymapping.lua`. Use `lazy-lock.json` for pinned plugin versions and `cspell.json` for custom dictionary entries.

## Build, Test, and Development Commands
Run `nvim` to load the config interactively during development. Use `nvim --headless "+Lazy! sync" +qa` to install or update plugins from the lockfile without opening the UI. Use `nvim --headless "+checkhealth" +qa` to validate runtime dependencies after changes. Format Lua files with `stylua .`. If startup performance is relevant, run `PROF=1 nvim` to enable the `snacks.nvim` profiler configured in `init.lua`.

## Coding Style & Naming Conventions
Follow `.stylua.toml`: spaces, 2-space indentation, 120-column width. Prefer small Lua modules with clear return tables and descriptive snake_case names such as `swift_config.lua` or `colorscheme.lua`. Keep plugin specs and mappings close to the feature they configure. Add comments only where intent is not obvious, especially around lazy-loading, autocommands, or nontrivial keymaps.

## Testing Guidelines
There is no dedicated automated test suite in this repo. Treat headless Neovim checks as the baseline validation path: run `stylua .`, `nvim --headless "+Lazy! sync" +qa`, and `nvim --headless "+checkhealth" +qa`. After changing keymaps, plugins, or language settings, open `nvim` and verify the affected workflow manually.

## Commit & Pull Request Guidelines
Recent history uses short Conventional Commit prefixes such as `feat:` and `fix:`. Keep commit subjects imperative and scoped to one change, for example `fix: diffview git` or `feat: swift support`. Pull requests should describe the user-visible behavior change, note any required external tools or language servers, and include screenshots or terminal snippets when UI behavior, diagnostics, or keymap flows changed.
