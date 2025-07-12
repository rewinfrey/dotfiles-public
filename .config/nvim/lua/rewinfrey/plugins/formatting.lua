return {
	{
		"stevearc/conform.nvim",
		lazy = false,
		opts = {
			format_on_save = {
				timeout_ms = 3000,
				lsp_fallback = true,
			},
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "goimports", "gofmt" },
				rust = { "rustfmt" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				markdown = { "prettier" },
				python = { "ruff_format" },
			},
			formatters = {
				ruff_format = {
					command = "ruff",
					args = { "format", "--stdin-filename", "$FILENAME", "-" },
					stdin = true,
				},
			},
		},
	},
}
