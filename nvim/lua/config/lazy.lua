-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

local ok, options_module = pcall(require, "config.options")
if not ok then
	vim.notify("Error to load the module " .. tostring(options_module), vim.log.levels.ERROR)
end

local ok, keymap_module = pcall(require, "config.keymap")
if not ok then
	vim.notify("Error to load the module " .. tostring(keymap_module), vim.log.levels.ERROR)
end

require("lazy").setup({
	spec = {
		{ import = "plugins" },
		{ import = "plugins.lsp" },
	},
	install = { colorscheme = { "tokyonight" } },
	checker = { enabled = false },
})
