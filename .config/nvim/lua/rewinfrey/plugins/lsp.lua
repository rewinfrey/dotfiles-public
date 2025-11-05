return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "folke/neodev.nvim",
    },
    config = function()
      local telescope = require("telescope.builtin")

      local on_attach = function(_, bufnr)
        local nmap = function(keys, func, desc)
          if desc then
            desc = "LSP: " .. desc
          end
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
        end

        nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
        nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
        nmap("gr", telescope.lsp_references, "[G]oto [R]eferences")
        nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
        nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
        nmap("<leader>ds", telescope.lsp_document_symbols, "[D]ocument [S]ymbols")
        nmap("<leader>ws", telescope.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
        nmap("K", vim.lsp.buf.hover, "Hover Documentation")
        nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
        nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
        nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
        nmap("<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, "[W]orkspace [L]ist Folders")

        vim.api.nvim_set_keymap(
          "n",
          "<leader>gv",
          '<cmd>lua require"telescope.builtin".lsp_definitions({jump_type="vsplit"})<CR>',
          { noremap = true, silent = true }
        )

        vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
          vim.lsp.buf.format()
        end, { desc = "Format current buffer with LSP" })
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok_cmp then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end

      local servers = {
        gopls = {},
        pyright = {
          settings = {
            python = {
              analysis = {
                diagnosticMode = "off", -- let Ruff handle linting
              },
              pythonPath = "./.venv/bin/python",
            },
          },
        },
        ruff = {
          cmd = { "uv", "run", "ruff", "server", "--preview" },
          -- Ruff uses init_options instead of settings
          init_options = {
            settings = {},
          },
        },
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,            -- enable if you commonly use features
                buildScripts = { enable = true },
              },
              checkOnSave = {
                command = "clippy",            -- run clippy on save
              },
              procMacro = { enable = true },
              inlayHints = {
                lifetimeElisionHints = { enable = true, useParameterNames = true },
                bindingModeHints = { enable = true },
                closureReturnTypeHints = { enable = "with_block" },
                implicitDrops = { enable = true },
              },
              -- Helpful if you use rustfmt nightly options:
              rustfmt = {
                extraArgs = {},                -- e.g. { "+nightly" }
              },
            },
          },
        },
      }

      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup({
        ensure_installed = vim.tbl_filter(function(server)
          return server ~= "rust_analyzer"
        end, vim.tbl_keys(servers)),
      })

      for _, server_name in ipairs(mason_lspconfig.get_installed_servers()) do
        local server_opts = {
          capabilities = capabilities,
          on_attach = on_attach,
        }

        local server = servers[server_name]
        if server then
          for k, v in pairs(server) do
            server_opts[k] = v
          end
        end

        -- https://github.com/neovim/nvim-lspconfig/blob/aafecf5b8bc0a768f1a97e3a6d5441e64dee79f9/doc/lspconfig.txt#L36
        -- vim.lsp.config(server_name, server_opts)
        vim.lsp.enable(server_name)
      end

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.py" },
        callback = function()
          -- Only format with Ruff if it's attached
          for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
            if client.name == "ruff" and client.supports_method("textDocument/formatting") then
              vim.lsp.buf.format({ async = false, name = "ruff" })
              return
            end
          end
        end,
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
  },
  {
    "folke/neodev.nvim",
    config = true,
  },
  {
    "glepnir/lspsaga.nvim",
    branch = "main",
    config = function()
      require("lspsaga").setup({})
      vim.keymap.set("n", "gc", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })
    end,
  },
}
