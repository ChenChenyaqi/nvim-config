# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a modern Neovim configuration using lazy.nvim as the plugin manager. The configuration is organized in a modular structure with plugins categorized by functionality.

## Architecture

### Core Structure
- `init.lua`: Main entry point with basic Vim settings and plugin manager bootstrap
- `lua/config/lazy.lua`: Lazy.nvim configuration and plugin loading
- `lua/keymapping.lua`: Global key mappings
- `lua/plugins/`: Plugin configurations organized by category

### Plugin Categories
- `ai.lua`: AI assistant plugins (Copilot)
- `colorscheme.lua`: Theme configuration (Catppuccin)
- `completion.lua`: Code completion (blink.cmp with multiple sources)
- `edit.lua`: Editing utilities
- `lsp.lua`: Language Server Protocol configuration
- `session.lua`: Session management
- `snacks.lua`: Performance profiling
- `treesitter.lua`: Syntax highlighting
- `ui.lua`: User interface components

## Key Configuration Details

### Plugin Manager
- Uses lazy.nvim with automatic installation
- Plugins are loaded from `lua/plugins/` directory
- Leader key: `<Space>`
- Local leader key: `\`

### Language Support
- **LSP Servers**: Lua, TypeScript, Vue, ESLint, HTML, CSS, JSON
- **Formatters**: Prettier (TypeScript/JavaScript/Vue), stylua (Lua)
- **Linters**: ESLint, codespell
- **Treesitter**: Auto-install enabled for common languages

### Key Mappings

#### Navigation
- `<C-h/j/k/l>`: Window navigation
- `<S-J/K>`: 5-line jumps
- `<S-H/L>`: Line start/end

#### File Operations
- `<C-s>`: Save file
- `Q`: Quit all files
- `qq`: Quit current file

#### Plugin Management
- `<leader>L`: Open Lazy.nvim

#### LSP Mappings
- `gh`: Hover documentation
- `<leader>d`: Show diagnostic
- `<leader>rn`: Rename symbol

#### Buffer Management
- `<A-h/l>`: Previous/next buffer
- `<A-1>..<A-9>`: Go to specific buffer
- `<A-</>>`: Move buffer left/right

#### Git Operations
- `]h/[h`: Next/previous hunk
- `<leader>ggs`: Stage hunk
- `<leader>ggr`: Reset hunk
- `<leader>ggp`: Preview hunk

#### Session Management
- `<leader>ps`: Restore session
- `<leader>pS`: Search session
- `<leader>pD`: Delete session

#### UI Toggles
- `<leader>tf`: Toggle auto-format
- `<leader>tgb`: Toggle git blame line
- `<leader>tgw`: Toggle git word diff

### UI Components
- **Theme**: Catppuccin with transparent background
- **Status Line**: lualine with Copilot integration
- **File Explorer**: nvim-tree
- **Buffer Bar**: barbar.nvim
- **Scrollbar**: nvim-scrollbar with git integration
- **Search**: nvim-hlslens with enhanced highlighting
- **Code Folding**: nvim-ufo with treesitter support

### Development Features
- **Auto-completion**: blink.cmp with LSP, Copilot, snippets, buffer sources
- **Formatting**: conform.nvim with auto-format on save
- **Linting**: nvim-lint with ESLint integration
- **Diagnostics**: trouble.nvim for organized error display
- **Git Integration**: gitsigns with inline blame and diff

### Performance
- Performance profiling available via snacks.nvim (set `PROF` environment variable)
- Built with lazy loading for optimal startup time

## Development Workflow

When modifying this configuration:
1. Edit plugin files in `lua/plugins/` directory
2. Test changes by restarting Neovim
3. Use `<leader>L` to manage plugins
4. Enable performance profiling with `PROF=1 nvim` if needed

## File Type Support

This configuration provides comprehensive support for:
- **Web Development**: TypeScript, JavaScript, Vue, HTML, CSS, JSON
- **Lua**: Full LSP and formatting support
- **Markdown**: Copilot suggestions enabled
- **Git**: Integrated diff and blame tools
