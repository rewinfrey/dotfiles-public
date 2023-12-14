local vim = vim
vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- Toggle word wrap
vim.keymap.set('n', '<leader>w', ':set wrap!<CR>')

-- Disable search highlighting
vim.keymap.set({ 'n', 'v' }, '<leader><space>', ':noh<CR>')

-- NerdTree keymaps
vim.keymap.set('n', '<leader>f', ':NERDTreeFind<CR>')
vim.keymap.set('n', '<leader>tt', ':NERDTreeToggle<CR>')

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
vim.keymap.set('n', '<leader>gb', ':w<CR>:GoBuild<CR>')
vim.keymap.set('n', '<leader>gt', ':GoTest<CR>')
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
vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'WinEnter' }, {
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

-- Lspsaga
vim.keymap.set('n', 'K', '<cmd>Lspsaga hover_doc<CR>')
vim.keymap.set('n', 'D', '<cmd>Lspsaga peek_definition<CR>')
vim.keymap.set('n', 'T', '<cmd>Lspsaga peek_type_definition<CR>')

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- View all keymaps
    vim.keymap.set('n', '<leader>km', require('telescope.builtin').keymaps)

    -- Tree-sitter picker
    vim.keymap.set('n', '<space>tp', require('telescope.builtin').treesitter)

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', '<leader>gv', ':vsplit | lua vim.lsp.buf.definition()<CR>', ops)
    vim.keymap.set('n', '<leader>gs', ':belowright split | lua vim.lsp.buf.definition()<CR>', ops)
    --vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<leader>ds', require('telescope.builtin').lsp_document_symbols, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
