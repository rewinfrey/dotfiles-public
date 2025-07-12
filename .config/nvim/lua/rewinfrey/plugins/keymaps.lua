require("rewinfrey.telescope")
return {
  {
    "folke/which-key.nvim",
    opts = {},
    init = function()
      local wk = require("which-key")
      local builtin = require("telescope.builtin")

      wk.add({
        { "<leader>w", ":set wrap!<CR>", desc = "Toggle Word Wrap" },
        { "<leader>m", ":MaximizerToggle<CR>", desc = "Maximize Buffer" },
        { "<leader>tt", ":NERDTreeToggle<CR>", desc = "Toggle NERDTree" },
        { "<leader>f", ":NERDTreeFind<CR>", desc = "Find in NERDTree" },
        {
          "<leader>n",
          ":edit $HOME/Library/Mobile Documents/com~apple~CloudDocs/Documents/Notes<CR>",
          desc = "Open Notes",
        },
        { "<leader>rr", ":source $MYVIMRC<CR>", desc = "Reload Neovim Config" },
        { "<leader>ss", ":source $MYVIMRC<CR>", desc = "Source Neovim Config" },
        { "<leader>ll", ":let @+=expand('%')<CR>", desc = "Copy relative file path" },
        { "<leader>lL", ":let @+=expand('%:p')<CR>", desc = "Copy absolute file path" },
        { "<leader>ts", ":tab split<CR>", desc = "Tab Split" },
        { "<leader>tc", ":tabclose<CR>", desc = "Tab Close" },
        { "<leader>to", ":tabonly<CR>", desc = "Tab Only" },
        { "<leader>1", ":tabnext 1<CR>", desc = "Tab 1" },
        { "<leader>2", ":tabnext 2<CR>", desc = "Tab 2" },
        { "<leader>3", ":tabnext 3<CR>", desc = "Tab 3" },
        { "<leader>4", ":tabnext 4<CR>", desc = "Tab 4" },
        { "<leader>5", ":tabnext 5<CR>", desc = "Tab 5" },
        { "<leader>6", ":tabnext 6<CR>", desc = "Tab 6" },
        { "<leader>7", ":tabnext 7<CR>", desc = "Tab 7" },
        { "<leader><space>", ":noh<CR>", desc = "Clear Highlight" },
        { "<leader>tw", ":ToggleStripWhitespace<CR>", desc = "Toggle Strip Whitespace" },

        -- Copilot insert mode mapping
        {
          "<C-l>",
          'copilot#Accept("<CR>")',
          desc = "Copilot: Accept suggestion",
          mode = "i",
          expr = true,
          replace_keycodes = false,
        },

        -- Git
        { "<leader>gb", ":G blame<CR>", desc = "Git Blame" },
        { "<leader>gl", ":G log<CR>", desc = "Git Log (Fugitive)" },
        { "<leader>gp", ":G log -S ", desc = "Git Pickaxe (Search)" },
        { "<leader>gs", "<cmd>LazyGit<cr>", desc = "LazyGit" },
        {
          "<leader>ggc",
          function()
            builtin.git_commits()
          end,
          desc = "Search Commits",
        },
        {
          "<leader>ggf",
          function()
            builtin.git_bcommits()
          end,
          desc = "Search File History",
        },
        {
          "<leader>ggB",
          function()
            builtin.git_branches()
          end,
          desc = "Git Branches",
        },
        {
          "<leader>ggS",
          function()
            builtin.git_status()
          end,
          desc = "Git Status",
        },

        -- Telescope / Search
        {
          "<leader>sc",
          function()
            builtin.colorscheme()
          end,
          desc = "Select Colorscheme",
        },
        {
          "<leader>so",
          function()
            builtin.oldfiles()
          end,
          desc = "Search Old Files",
        },
        {
          "<leader>sb",
          function()
            builtin.buffers()
          end,
          desc = "Search Buffers",
        },
        {
          "<leader>sf",
          function()
            builtin.find_files()
          end,
          desc = "Search Files",
        },
        {
          "<leader>p",
          function()
            if vim.fn.system("git rev-parse --is-inside-work-tree") == "true\n" then
              builtin.git_files()
            else
              builtin.find_files()
            end
          end,
          desc = "Search Project Files",
        },
        {
          "<leader>sh",
          function()
            builtin.help_tags()
          end,
          desc = "Search Help",
        },
        {
          "<leader>sk",
          function()
            builtin.keymaps()
          end,
          desc = "Search Keymaps",
        },
        {
          "<leader>sw",
          function()
            builtin.grep_string()
          end,
          desc = "Search Word",
        },
        {
          "<leader>s?",
          function()
            builtin.live_grep()
          end,
          desc = "Live Grep",
        },
        {
          "<leader>sd",
          function()
            builtin.diagnostics()
          end,
          desc = "Search Diagnostics",
        },
        {
          "<leader>st",
          function()
            builtin.treesitter()
          end,
          desc = "Search Tree-sitter",
        },
        {
          "<leader>si",
          function()
            builtin.builtin()
          end,
          desc = "Search Builtin",
        },
        {
          "<leader>s/",
          function()
            builtin.current_buffer_fuzzy_find()
          end,
          desc = "Fuzzy Search Buffer",
        },

        -- LSP
        {
          "<leader>rn",
          function()
            vim.lsp.buf.rename()
          end,
          desc = "LSP Rename",
        },
        {
          "<leader>ca",
          function()
            vim.lsp.buf.code_action()
          end,
          desc = "LSP Code Action",
        },
        {
          "<leader>gd",
          function()
            builtin.lsp_definitions()
          end,
          desc = "Goto Definition",
        },
        {
          "<leader>gr",
          function()
            builtin.lsp_references()
          end,
          desc = "Goto References",
        },
        {
          "<leader>gI",
          function()
            vim.lsp.buf.implementation()
          end,
          desc = "Goto Implementation",
        },
        {
          "<leader>D",
          function()
            vim.lsp.buf.type_definition()
          end,
          desc = "Type Definition",
        },
        {
          "<leader>ds",
          function()
            builtin.lsp_document_symbols()
          end,
          desc = "Document Symbols",
        },
        {
          "<leader>ws",
          function()
            builtin.lsp_dynamic_workspace_symbols()
          end,
          desc = "Workspace Symbols",
        },
        {
          "<leader>K",
          function()
            vim.lsp.buf.hover()
          end,
          desc = "Hover Doc",
        },
        {
          "<leader><C-k>",
          function()
            vim.lsp.buf.signature_help()
          end,
          desc = "Signature Help",
        },
        {
          "<leader>gD",
          function()
            vim.lsp.buf.declaration()
          end,
          desc = "Goto Declaration",
        },
        {
          "<leader>wa",
          function()
            vim.lsp.buf.add_workspace_folder()
          end,
          desc = "Add Workspace Folder",
        },
        {
          "<leader>wr",
          function()
            vim.lsp.buf.remove_workspace_folder()
          end,
          desc = "Remove Workspace Folder",
        },
        {
          "<leader>wl",
          function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end,
          desc = "List Workspace Folders",
        },
        {
          "<leader>gv",
          '<cmd>lua require"telescope.builtin".lsp_definitions({jump_type="vsplit"})<CR>',
          desc = "Goto Definition VSplit",
        },
        { "<leader>tp", ":TSPlaygroundToggle<CR>", desc = "Toggle TS Playground" },
        {
          "<leader>rf",
          function()
            require("conform").format({ async = true, lsp_fallback = true })
          end,
          desc = "Format Buffer",
        },
        {
          "<leader>e",
          function()
            vim.diagnostic.open_float()
          end,
          desc = "Show Diagnostic Float",
        },
        {
          "<leader>q",
          function()
            vim.diagnostic.setloclist()
          end,
          desc = "Set Location List",
        },

        -- Diagnostics Navigation
        {
          "[d",
          function()
            vim.diagnostic.goto_prev()
          end,
          desc = "Prev Diagnostic",
        },
        {
          "]d",
          function()
            vim.diagnostic.goto_next()
          end,
          desc = "Next Diagnostic",
        },
      })

      vim.keymap.set("n", "<C-s>", ":w<CR>")
      vim.keymap.set("n", "Q", ":q<CR>")
    end,
  },
}
