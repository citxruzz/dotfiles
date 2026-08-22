return {
	"mbbill/undotree",
	config = function()
		vim.keymap.set("n", "<leader>u", ':UndotreeToggle<CR><C-w>w', { desc = "Toggle undotree" })
	end,
}
