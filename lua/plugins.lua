local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
	use ("wbthomason/packer.nvim") -- Have packer manage itself
	use 'fedepujol/move.nvim'
  use 'kassio/neoterm'
	use 'cdelledonne/vim-cmake'
	use 'Mofiqul/vscode.nvim'
	use 'lewis6991/gitsigns.nvim'
	use 'neovim/nvim-lspconfig'  -- LSP configurations
	use 'hrsh7th/nvim-cmp'       -- Completion engine
  use 'hrsh7th/cmp-nvim-lsp'   -- LSP source for nvim-cmp
  use 'hrsh7th/cmp-buffer'     -- Buffer completions
  use 'hrsh7th/cmp-path'       -- Path completions
  use 'hrsh7th/cmp-cmdline'    -- Command-line completions
	use 'sakhnik/nvim-gdb'
	use {'nvim-telescope/telescope.nvim', tag = '0.1.2', requires = { {'nvim-lua/plenary.nvim'} }}
	use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
	use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }

	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
