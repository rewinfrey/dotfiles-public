return {
  -- Theme plugins
  { "rose-pine/neovim", name = "rose-pine" },
  { "EdenEast/nightfox.nvim" },
  { "navarasu/onedark.nvim" },
  { "rigellute/shades-of-purple.vim" },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("lualine").setup()
    end,
  },

  -- Telescope colorscheme picker keymap
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    config = function()
      vim.keymap.set("n", "<leader>sc", require("telescope.builtin").colorscheme, {
        desc = "[S]elect [C]olorscheme",
      })
    end,
  },

  -- Mini-icons
  {
    "echasnovski/mini.icons",
    version = false,
    config = function()
      require("mini.icons").setup()
    end,
  },
}
