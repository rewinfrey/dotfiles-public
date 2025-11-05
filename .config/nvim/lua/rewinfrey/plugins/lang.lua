return {
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
