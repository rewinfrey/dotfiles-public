return {
	{
		"zbirenbaum/copilot.lua",
		-- requires = {
		-- 	"copilotlsp-nvim/copilot-lsp",
		-- 	init = function()
		-- 		vim.g.copilot_nes_debounce = 500
		-- 	end,
		-- },
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				filetypes = {
					[''] = false, -- This is a temporary fix for copilot keymap breaking: https://github.com/zbirenbaum/copilot.lua/issues/577#issuecomment-3337086552
					-- markdown = true, -- overrides default
					-- sh = function ()
					-- 	if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%.env.*') then
					-- 		-- disable for .env files
					-- 		return false
					-- 	end
					-- 	return true
					-- end,
				},
				suggestion = {
					enabled = true,
					auto_trigger = true,
					debounce = 75,
					keymap = {
						accept = "<C-l>",
						next = "<M-]>",
						prev = "<M-[>",
						dismiss = "<C-]>",
					},
				},
				-- I would like to try the next edit suggestion functionality out, but currently it is not working for me.
				-- nes = {
				-- 	enabled = true,
				-- 	keymap = {
				-- 		accept_and_goto = "<C-g>",
				-- 		accept = false,
				-- 		dismiss = "<Esc>",
				-- 	},
				-- },
				panel = { enabled = false },
			})

			-- Inline ghost text highlight (soft gray)
			vim.cmd([[highlight CopilotSuggestion guifg=#555555 ctermfg=8]])
		end,
	},
}

