return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	opts = {},
	config = function()
		require("tokyonight").setup({
			style = "night", -- The 'storm' style is the original TokyoNight theme
			transparent = true, -- Enable this to disable setting the background color
			terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
			styles = {
				comments = { italic = true },
				keywords = { italic = true },
				functions = {},
				variables = {},
				sidebars = "transparent", -- Set the theme for sidebars, can be 'dark', 'light', or 'transparent'
				floats = "transparent", -- Set the theme for floating windows, can be 'dark', 'light', or 'transparent'
			},
			sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows
			on_colors = function(colors) end, -- Override colors
			on_highlights = function(highlights, colors) end, -- Override highlights
		})
		vim.cmd("colorscheme tokyonight-night")
	end,
}
