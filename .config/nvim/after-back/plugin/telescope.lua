local M = {}
local vim = vim
local actions = require 'telescope.actions'
local telescope = require 'telescope'
telescope.setup {
	defaults = {
		mappings = {
			i = {
				["<C-u>"] = false,
				["<C-d>"] = false,
				["<esc>"] = actions.close,
				["<C-[>"] = actions.close,
				["<C-s>"] = actions.send_to_qflist + actions.open_qflist,
			},
		},
		layout_config = {
			horizontal = {
				prompt_position = 'top',
				width = .90,
			},
		},
		sorting_strategy = 'ascending',
		options = {
			fname_width = 60,
			symbol_width = 80,
			symbol_type_width = 16,
		},
	},
}

-- Enable telescope fzf native
telescope.load_extension('fzf')
-- Enable lazygit extension
telescope.load_extension('lazygit')

M.project_files = function()
	local opts = {} -- define here if you want to define something
	vim.fn.system('git rev-parse --is-inside-work-tree')
	if vim.v.shell_error == 0 then
		require "telescope.builtin".git_files(opts)
	else
		require "telescope.builtin".find_files(opts)
	end
end

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>so', require('telescope.builtin').oldfiles, { desc = '[?] [S]earch [O]ld files' })
vim.keymap.set('n', '<leader>sb', require('telescope.builtin').buffers, { desc = '[ ] [S]earch [B]uffers' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sp', require('telescope.builtin').git_files, { desc = '[S]earch [P]roject' })
vim.keymap.set('n', '<leader>p', M.project_files, { desc = '[S]earch [P]roject files' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>?', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>st', require('telescope.builtin').treesitter, { desc = '[S]earch [T]ree-sitter' })
vim.keymap.set('n', '<leader>si', require('telescope.builtin').builtin, { desc = '[S]earch [B]uiltin' })
vim.keymap.set('n', '<leader>gd', require('telescope.builtin').lsp_definitions, { desc = '[G]oto [D]efinition' })
vim.keymap.set('n', '<leader>gr', require('telescope.builtin').lsp_references, { desc = '[G]oto [R]eferences' })
vim.keymap.set('n', '<leader>/', function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
		--winblend = 10,
		--previewer = false,
	})
end, { desc = '[/] Fuzzily search in current buffer]' })
vim.keymap.set('n', '<leader>lg', ':LazyGit<CR>')

vim.cmd [[
  autocmd BufEnter * :lua require('lazygit.utils').project_root_dir()
]]

return M
