local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { import = "rewinfrey.plugins" }, -- automatically loads all modules in plugins/
}, {
  defaults = {
    lazy = false, -- load everything unless explicitly marked lazy
  },
  install = {
    missing = true,
    colorscheme = { "rose-pine" },
  },
  checker = { enabled = true }, -- auto-check for plugin updates
})
