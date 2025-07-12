return {
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
	},
	{ "tpope/vim-sleuth" },
	{ "tpope/vim-surround" },
	{ "tpope/vim-repeat" },
	{ "szw/vim-maximizer" },
	{ "preservim/nerdtree" },
}
