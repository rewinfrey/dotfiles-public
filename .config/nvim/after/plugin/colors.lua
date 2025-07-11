local vim = vim
function ColorMe(color)
	color = color or "rose-pine"
	vim.cmd.colorscheme(color)
end

ColorMe()

-- ✨ Reapply transparency *after* colorscheme loads
-- vim.api.nvim_set_hl(0, "Normal",      { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalNC",    { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
-- vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
-- vim.api.nvim_set_hl(0, "SignColumn",  { bg = "none" })
-- vim.api.nvim_set_hl(0, "VertSplit",   { bg = "none" })
