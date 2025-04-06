return {
	"github/copilot.vim",
	config = function()
		vim.g.copilot_no_tab_map = true -- Prevents Copilot from taking over <Tab>
		vim.g.copilot_assume_mapped = true

		-- Alt-based keybindings for Copilot
		vim.api.nvim_set_keymap("i", "<A-y>", 'copilot#Accept("<CR>")', { expr = true, silent = true })
		vim.api.nvim_set_keymap("i", "<A-j>", "copilot#Next()", { expr = true, silent = true })
		vim.api.nvim_set_keymap("i", "<A-k>", "copilot#Previous()", { expr = true, silent = true })
		vim.api.nvim_set_keymap("i", "<A-e>", "copilot#Dismiss()", { expr = true, silent = true })
		vim.api.nvim_set_keymap("i", "<A-n>", "copilot#Suggest()", { expr = true, silent = true })

		-- Optional: Open Copilot panel in normal mode with Alt + P
		vim.api.nvim_set_keymap("n", "<A-h>", ":Copilot panel<CR>", { silent = true })
	end,
}
