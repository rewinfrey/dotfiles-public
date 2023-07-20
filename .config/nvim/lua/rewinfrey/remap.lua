local vim = vim
vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- Toggle word wrap
vim.keymap.set('n', '<leader>w', ':set wrap!<CR>')

-- Disable search highlighting
vim.keymap.set({ 'n', 'v' }, '<leader><space>', ':noh<CR>')

-- NerdTree keymaps
vim.keymap.set('n', '<leader>nf', ':NERDTreeFind<CR>')
vim.keymap.set('n', '<leader>nt', ':NERDTreeToggle<CR>')

-- Yank the current buffer's relative file path to the system's paste buffer
vim.keymap.set('n', '<leader>l', ':let @+=expand("%")<CR>')

-- Yank the current buffer's absolute file path to the system's paste buffer
vim.keymap.set('n', '<leader>L', ':let @+=expand("%:p")<CR>')

vim.keymap.set('n', '<C-s>', ':w<CR>')
vim.keymap.set('n', 'Q', ':q<CR>')

-- MarkdownPreview
vim.keymap.set('n', '<leader>mp', ':MarkdownPreview<CR>')

-- Custom function for defining vim keymaps
function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Remap for dealing with word wrap
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })


-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
map('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Notes
vim.keymap.set('n', '<leader>n', ':edit $HOME/Library/Mobile Documents/com~apple~CloudDocs/Documents/Notes<CR>')

-- Tabs
vim.keymap.set('n', '<leader>ts', ':tab split<CR>')
vim.keymap.set('n', '<leader>tc', ':tabclose<CR>')
vim.keymap.set('n', '<leader>to', ':tabonly<CR>')
vim.keymap.set('n', '<leader>1', ':tabnext 1<CR>')
vim.keymap.set('n', '<leader>2', ':tabnext 2<CR>')
vim.keymap.set('n', '<leader>3', ':tabnext 3<CR>')
vim.keymap.set('n', '<leader>4', ':tabnext 4<CR>')
vim.keymap.set('n', '<leader>5', ':tabnext 5<CR>')
vim.keymap.set('n', '<leader>6', ':tabnext 6<CR>')
vim.keymap.set('n', '<leader>7', ':tabnext 7<CR>')

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Go build
vim.keymap.set('n', '<leader>b', ':w<CR>:GoBuild<CR>')
vim.keymap.set('n', '<leader>t', ':GoTest<CR>')
vim.keymap.set('n', '<C-n>', ':cnext<CR>')
vim.keymap.set('n', '<C-p>', ':cprevious<CR>')

-- Go to def vertical split (requires vim-go)
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  callback = function(_)
    vim.keymap.set('n', 'gv', '<Plug>(go-def-vertical)')
  end
})

-- Go to def horizontal split (requires vim-go)
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  callback = function(_)
    vim.keymap.set('n', 'gs', '<Plug>(go-def-split)')
  end
})

-- Go to def tab split (requires vim-go)
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  callback = function(_)
    vim.keymap.set('n', 'gt', '<Plug>(go-def-tab)')
  end
})

-- Toggle line number mode
vim.api.nvim_create_autocmd('BufEnter,FocusGained,InsertLeave,WinEnter', {
  pattern = '*',
  callback = function(args)
  end
})

-- show cursor line only in active window
local cursorGrp = vim.api.nvim_create_augroup("CursorLine", { clear = true })
vim.api.nvim_create_autocmd(
  { 'InsertLeave', 'WinEnter' },
  { pattern = "*", command = "set cursorline", group = cursorGrp }
)
vim.api.nvim_create_autocmd(
  { 'InsertEnter', 'WinLeave' },
  { pattern = '*', command = 'set nocursorline', group = cursorGrp }
)
