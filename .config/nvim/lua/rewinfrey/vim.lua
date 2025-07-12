local vim = vim
-- Vim configuration
-- See `:help vim.o`

-- Set the leader
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Disable swap files
vim.o.swapfile = false

-- Disable netrw and enable nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Disable word wrapping
vim.o.wrap = false

-- Highlight on search
vim.o.hlsearch = true

-- Highlight the current cursor line
vim.o.cursorline = true

-- Set column guide
vim.opt.colorcolumn = "80"

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set colorscheme
vim.o.termguicolors = true

-- Set clipboard to share pastebuffer when yanking in vim
vim.o.clipboard = 'unnamed'

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Go related configuration
vim.g.go_fmt_autosave = 1
vim.g.go_imports_mode = 'goimports-reviser'

-- Set default spacing
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.expandtab = true

-- Rust related configuration
vim.g.rustfmt_autosave = 1

-- Vertical and horizontal splits
vim.o.splitright = true
vim.o.splitbelow = true

-- Global statusline
vim.o.laststatus = 3

-- Detect tsg files
vim.cmd [[
  autocmd BufREad,BufNewFile *.tsg set filetype=tsg
]]

vim.cmd [[
  autocmd BufWritePre * if &filetype != 'markdown' | %s/\s\+$//e | endif
]]

vim.cmd [[
  autocmd BufWritePre * lua if vim.bo.filetype ~= "sql" then vim.lsp.buf.format() end
]]

-- Always enable spell checking
vim.cmd [[
  autocmd BufRead,BufNewFile * setlocal spell spelllang=en_us
]]

-- MarkdownPreview configuration
vim.g.mkdp_page_title = ''

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
