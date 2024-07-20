vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.mouse = "a"

opt.showmode = false

-- opt.clipboard = "unnamedplus"

--tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.breakindent = true
opt.autoindent = true

opt.undofile = true

opt.wrap = true

--search setting
opt.ignorecase = true
opt.smartcase = true

opt.updatetime = 50

opt.timeoutlen = 300

--splits
opt.splitright = true
opt.splitbelow = true

--for white space characters
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

opt.inccommand = "split"

opt.scrolloff = 10

opt.hlsearch = true
opt.incsearch = true

opt.cursorline = true

opt.signcolumn = "yes"

--autosave
local autosave_group = vim.api.nvim_create_augroup("autosave", { clear = true })
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
	pattern = "*",
	command = "silent! wall",
	group = autosave_group,
})
