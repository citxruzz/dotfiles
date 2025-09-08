local keymap = vim.keymap

--for ESC
keymap.set("i", "jf", "<ESC>", { desc = "Exit insert mode with leader>;" })

--for elplorer
keymap.set("n", "<leader>pv", vim.cmd.Ex)

--highlight on search, but clear when ESC is pressed in normal mode
keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

--move
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move the line down" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move the line up" })

-- Indent while keeping selection
keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Diagnostic keymaps
keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

--to exit terminal mode ESC ESC
keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

--delete when paste
keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without coping" })

--for split navigation
keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

--window managemnet
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split horizontally" })
keymap.set("n", "<leader>se", "<C-w>v", { desc = "Make equal space" })
keymap.set("n", "<leader>sr", "<cmd>close<CR>", { desc = "Close current split" })

--for tabs
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Goto next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Goto prev tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

--yank to system
keymap.set("n", "<leader>y", '"+y', { desc = "Yank to system clipboard" })
keymap.set("v", "<leader>y", '"+y', { desc = "Yank to system clipboard" })
keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank from cursor-line to system clipboard" })

--keymap for ease
keymap.set("n", "<leader>va", "GVgg", { desc = "Select all" })

--basic auto command for highlight when yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
