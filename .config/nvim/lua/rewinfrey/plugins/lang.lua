return {
	-- Rust support (via rust-tools)
	{
		"simrat39/rust-tools.nvim",
		ft = "rust",
		opts = {
			server = {
				on_attach = function(_, bufnr)
					local rt = require("rust-tools")
					vim.keymap.set("n", "<leader>ca", rt.code_action_group.code_action_group, {
						buffer = bufnr,
						desc = "Rust Code Actions",
					})
				end,
			},
		},
		dependencies = {
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
		},
		config = function(_, opts)
			require("rust-tools").setup(opts)
		end,
	},

	-- Go support (vim-go for tooling, gopls via LSP)
	{
		"fatih/vim-go",
		ft = { "go" },
		config = function()
			vim.g.go_fmt_command = "goimports"
			vim.g.go_doc_keywordprg_enabled = 0
		end,
	},
}
