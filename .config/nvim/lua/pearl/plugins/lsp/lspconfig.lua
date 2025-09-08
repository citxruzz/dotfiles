return {

	"neovim/nvim-lspconfig",

	event = { "BufReadPre", "BufNewFile" },

	dependencies = {

		"hrsh7th/cmp-nvim-lsp",

		{ "antosha417/nvim-lsp-file-operations", config = true },

		{ "folke/neodev.nvim", opts = {} },
	},

	config = function()
		local lspconfig = require("lspconfig")

		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Diagnostic signs

		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }

		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type

			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		vim.api.nvim_create_autocmd("LspAttach", {

			group = vim.api.nvim_create_augroup("UserLspConfig", {}),

			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }

				local keymap = vim.keymap

				opts.desc = "Show LSP references"

				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

				opts.desc = "Go to declaration"

				keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

				opts.desc = "Show LSP definitions"

				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

				opts.desc = "Show LSP implementations"

				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

				opts.desc = "Show LSP type definitions"

				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

				opts.desc = "See code actions"

				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

				opts.desc = "Smart rename"

				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

				opts.desc = "Buffer diagnostics"

				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

				opts.desc = "Line diagnostics"

				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

				opts.desc = "Prev diagnostic"

				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

				opts.desc = "Next diagnostic"

				keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

				opts.desc = "Hover docs"

				keymap.set("n", "K", vim.lsp.buf.hover, opts)

				opts.desc = "Restart LSP"

				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
			end,
		})

		for _, server in ipairs(require("mason-lspconfig").get_installed_servers()) do
			vim.lsp.config(server, default)
		end

		-- New v2+ API: define configs

		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		vim.lsp.config["*"] = {
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				local map = function(mode, lhs, rhs)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
				end
				map("n", "gd", vim.lsp.buf.definition)
				map("n", "K", vim.lsp.buf.hover)
			end,
		}
		vim.lsp.config("lua_ls", {

			capabilities = capabilities,

			settings = {

				Lua = {

					diagnostics = { globals = { "vim" } },

					completion = { callSnippet = "Replace" },
				},
			},
		})

		vim.lsp.config("emmet_ls", {

			capabilities = capabilities,

			filetypes = {
				"html",
				"typescriptreact",
				"javascriptreact",
				"css",
				"sass",
				"scss",
				"less",
				"svelte",
			},
		})

		vim.lsp.config("tsserver", {
			capabilities = capabilities,
			settings = {
				javascript = { suggest = { autoImports = true } },
				typescript = { suggest = { autoImports = true } },
			},
		})
	end,
}
