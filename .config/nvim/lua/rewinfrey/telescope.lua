local telescope = require("telescope")
local actions = require("telescope.actions")

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
    layout_strategy = "horizontal",
    sorting_strategy = "ascending",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        width = 0.90,
      },
    },
    options = {
      fname_width = 60,
      symbol_width = 80,
      symbol_type_width = 16,
    },
  },
})
