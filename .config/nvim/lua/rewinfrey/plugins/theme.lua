return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      require("rose-pine").setup({
        styles = { italic = false },
        disable_italics = true,
        dark_variant = "moon",
      })
      vim.cmd.colorscheme("rose-pine")
    end,
  },
  { "EdenEast/nightfox.nvim" },
  { "navarasu/onedark.nvim" },
  { "rigellute/shades-of-purple.vim" },
}
