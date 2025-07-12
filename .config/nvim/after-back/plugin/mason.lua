local vim = vim
local telescope = require('telescope.builtin')

-- Skip setup during bootstrap (optional)
if _G.is_bootstrap then
  return
end

-- Setup mason
local ok_mason, mason = pcall(require, "mason")
if not ok_mason then
  vim.notify("[mason] not available", vim.log.levels.WARN)
  return
end
mason.setup()

-- on_attach and keymaps
local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', telescope.lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', telescope.lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', telescope.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  vim.api.nvim_set_keymap('n', '<leader>gv',
    '<cmd>lua require"telescope.builtin".lsp_definitions({jump_type="vsplit"})<CR>',
    { noremap = true, silent = true })

  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- LSP servers to install
local servers = {
  gopls = {},
  rust_analyzer = {},
}

-- Setup mason-lspconfig
local ok_mason_lspconfig, mason_lspconfig = pcall(require, "mason-lspconfig")
if not ok_mason_lspconfig then
  vim.notify("[mason-lspconfig] not available", vim.log.levels.WARN)
  return
end

mason_lspconfig.setup({
  ensure_installed = vim.tbl_keys(servers),
})

-- LSP client capabilities (e.g., for nvim-cmp)
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end

-- Prefer setup_handlers if available
if mason_lspconfig.setup_handlers then
  mason_lspconfig.setup_handlers({
    function(server_name)
      require("lspconfig")[server_name].setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = servers[server_name],
      })
    end,
  })
else
  -- fallback: manually setup installed servers
  vim.notify("[mason-lspconfig] setup_handlers missing; falling back", vim.log.levels.WARN)
  for _, server_name in ipairs(mason_lspconfig.get_installed_servers()) do
    require("lspconfig")[server_name].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    })
  end
end
