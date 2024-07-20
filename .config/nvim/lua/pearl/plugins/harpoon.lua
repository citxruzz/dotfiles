return {
	"ThePrimeagen/harpoon",
	config = function()
		local mark = require("harpoon.mark")
		local ui = require("harpoon.ui")

		local keymap = vim.keymap.set

		keymap("n", "<leader>a", mark.add_file, { desc = "Add file to harpoon" })
		keymap("n", "<C-e>", ui.toggle_quick_menu, { desc = "Toggle harpoon" })

		keymap("n", "<C-h>", function()
			ui.nav_file(1)
		end, { desc = "Move to first file" })
		keymap("n", "<C-t>", function()
			ui.nav_file(2)
		end, { desc = "Move to first file" })
		keymap("n", "<C-n>", function()
			ui.nav_file(3)
		end, { desc = "Move to first file" })
		keymap("n", "<C-s>", function()
			ui.nav_file(4)
		end, { desc = "Move to first file" })
	end,
}
