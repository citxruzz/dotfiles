vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

-- Disable netrw workaround for vim-tmux-navigator
vim.g.tmux_navigator_disable_netrw_workaround = 1

require("pearl.core.remap")
require("pearl.core.options")
