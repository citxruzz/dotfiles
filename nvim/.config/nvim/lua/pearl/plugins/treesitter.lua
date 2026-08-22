return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	dependencies = {
		{
			"windwp/nvim-ts-autotag",
			config = function()
				require("nvim-ts-autotag").setup({})
			end,
		},
	},
	config = function()
		local treesitter = require("nvim-treesitter")

		treesitter.setup({})

		treesitter.install({
			"json",
			"javascript",
			"typescript",
			"tsx",
			"yaml",
			"html",
			"css",
			"prisma",
			"markdown",
			"markdown_inline",
			"bash",
			"lua",
			"vim",
			"dockerfile",
			"gitignore",
			"query",
			"c",
			"java",
			"cpp",
			"python",
			"rust",
		})

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("pearl_treesitter", { clear = true }),
			pattern = {
				"json",
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"yaml",
				"html",
				"css",
				"prisma",
				"markdown",
				"bash",
				"sh",
				"lua",
				"vim",
				"dockerfile",
				"gitignore",
				"query",
				"c",
				"java",
				"cpp",
				"python",
				"rust",
			},
			callback = function(args)
				pcall(vim.treesitter.start, args.buf)
				vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
