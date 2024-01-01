-- Install packer
local vim = vim
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	is_bootstrap = true
	vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
	vim.cmd [[packadd packer.nvim]]
end

require('packer').startup({
	function(use)
		-- Package manager
		use 'wbthomason/packer.nvim'

		use { -- LSP Configuration & Plugins
			'neovim/nvim-lspconfig',
			requires = {
				-- Automatically install LSPs to stdpath for neovim
				'williamboman/mason.nvim',
				'williamboman/mason-lspconfig.nvim',

				-- Useful status updates for LSP
				-- 'j-hui/fidget.nvim',

				-- Additional lua configuration, makes nvim stuff amazing
				'folke/neodev.nvim',
			},
		}

		use {
			'justinmk/vim-sneak'
		}

		use {
			'ggandor/leap.nvim',
		}

		use { -- Autocompletion
			'hrsh7th/nvim-cmp',
			requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
		}

		use {
			"zbirenbaum/copilot.lua",
			cmd = "Copilot",
			event = "InsertEnter",
			config = function()
				require("copilot").setup({
					panel = {
						enabled = true,
						auto_refresh = true,
					},
					suggestion = {
						enabled = true,
						auto_trigger = true,
					},
				})
			end,
		}

		use {
			"zbirenbaum/copilot-cmp",
			after = { "copilot.lua" },
			config = function()
				require("copilot_cmp").setup()
			end
		}

		use {
			"preservim/nerdtree",
		}

		use { -- Highlight, edit, and navigate code
			'nvim-treesitter/nvim-treesitter',
			run = function()
				pcall(require('nvim-treesitter.install').update { with_sync = true })
			end,
		}

		use { -- Additional text objects via treesitter
			'nvim-treesitter/nvim-treesitter-textobjects',
			after = 'nvim-treesitter',
		}

		use 'nvim-treesitter/playground'

		-- Toggle between relative line numbers (active buffer) and absolute line numbers (inactive buffers)
		use 'jeffkreeftmeijer/vim-numbertoggle'

		-- Maximize current buffer and restore
		use 'szw/vim-maximizer'

		-- Go related plugins
		use 'fatih/vim-go'

		-- Rust
		use 'rust-lang/rust.vim'

		-- Git related plugins
		use 'tpope/vim-fugitive'
		use 'tpope/vim-rhubarb'
		use 'lewis6991/gitsigns.nvim'

		use({
			'rose-pine/neovim',
			as = 'rose-pine',
			config = function()
				require('rose-pine').setup({ disable_italics = true, dark_variant = 'moon' })
			end
		})
		use "EdenEast/nightfox.nvim"
		use "navarasu/onedark.nvim"
		use "rigellute/shades-of-purple.vim"

		use {
			'nvim-lualine/lualine.nvim',
			requires = { 'nvim-tree/nvim-web-devicons', opt = true }
		}

		use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines
		use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
		use 'tpope/vim-sleuth'      -- Detect tabstop and shiftwidth automatically
		use 'tpope/vim-surround'

		-- Fuzzy Finder (files, lsp, etc)
		use({
			'nvim-telescope/telescope.nvim',
			requires = { { 'nvim-lua/plenary.nvim' }, { 'kdheepak/lazygit.nvim' } },
		})

		-- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
		use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }
		use 'junegunn/fzf'

		-- Provides better code navigation experience for definitions / references.
		use({
			"glepnir/lspsaga.nvim",
			branch = "main",
			config = function()
				require('lspsaga').setup({})
			end,
		})

		-- Markdown Preview
		use({
			"iamcco/markdown-preview.nvim",
			run = function()
				vim.fn["mkdp#util#install"]()
			end,
		})

		use({ "tpope/vim-repeat" })

		-- Terminal in buffer
		use {
			'boltlessengineer/bufterm.nvim',
			config = function()
				require('bufterm').setup()
			end,
		}

		-- Auto formatting
		use 'mhartington/formatter.nvim'

		-- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
		local has_plugins, plugins = pcall(require, 'custom.plugins')
		if has_plugins then
			plugins(use)
		end

		if is_bootstrap then
			require('packer').sync()
		end
	end,
	-- Configure Packer to use floating window
	config = {
		display = {
			open_fn = function()
				return require("packer.util").float({ border = "single" })
			end,
		},
	},
})

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
	command = 'source <afile> | PackerCompile',
	group = packer_group,
	pattern = vim.fn.expand '$MYVIMRC',
})

-- Autocommand that reloads neovim and installs/updates/removes plugins when file is saved
vim.cmd([[
  augroup packer_user_config
  autocmd!
  autocmd BufWritePost packer.lua source <afile> | PackerSync
  augroup end
]])
