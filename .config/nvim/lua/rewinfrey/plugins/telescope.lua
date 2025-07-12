return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "kdheepak/lazygit.nvim",
    },
    config = function()
      local actions = require("telescope.actions")
      local telescope = require("telescope")

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,
              ["<esc>"] = actions.close,
              ["<C-[>"] = actions.close,
              ["<C-s>"] = actions.send_to_qflist + actions.open_qflist,
            },
          },
          layout_config = {
            horizontal = {
              prompt_position = "top",
              width = 0.90,
            },
          },
          sorting_strategy = "ascending",
          options = {
            fname_width = 60,
            symbol_width = 80,
            symbol_type_width = 16,
          },
        },
      })

      telescope.load_extension("fzf")
      telescope.load_extension("lazygit")

      local builtin = require("telescope.builtin")
      local themes = require("telescope.themes")
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    cond = vim.fn.executable("make") == 1,
  },
  { "junegunn/fzf" },
}
