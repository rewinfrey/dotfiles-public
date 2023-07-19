local vim = vim
function ColorMe(color)
	color = color or "rose-pine"
	--color = color or "shades_of_purple"
	--color = color or "dawnfox"
	vim.cmd.colorscheme(color)
end

ColorMe()
