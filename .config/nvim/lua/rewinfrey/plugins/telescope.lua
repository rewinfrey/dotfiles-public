return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "kdheepak/lazygit.nvim",
    },
    lazy = true, -- loaded manually in keymaps.lua
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    cond = vim.fn.executable("make") == 1,
    lazy = false,
  },
  {
    "junegunn/fzf",
    lazy = false,
  },
}
