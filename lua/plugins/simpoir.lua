return {
	-- Appearance
	----------------------------------------
	{ "flazz/vim-colorschemes", lazy = false }, -- one of the largest/oldest theme collection
	{ "tanvirtin/monokai.nvim", lazy = false },
	"mhinz/vim-signify",        -- like gitgutter for all
	"liuchengxu/vim-which-key", -- the backslash menu
	"yggdroot/indentLine",      -- show line indentation for expandtabs
	"exvim/ex-showmarks",       -- show (book)marks in gutter
	"nvim-tree/nvim-web-devicons", -- icons mapping, required by tree and compl

	-- LSP and IDE lang stack
	----------------------------------------
	{ "williamboman/mason.nvim", lazy = false }, -- lsp, dap, linter, formatter installer
	{
		"williamboman/mason-lspconfig.nvim",
		opts = { automatic_installation = true },
		dependencies = {"mason.nvim"},
	},
	"neovim/nvim-lspconfig", -- common configs for LSP
	"mfussenegger/nvim-dap", -- debug adapter protocol
	"dgagn/diagflow.nvim", -- hovering lsp diagnostics
	"theHamsta/nvim-dap-virtual-text", -- show variables inline in debug
	"nvim-lua/plenary.nvim",        -- lua boilerplate, for telescope

	-- Coding
	----------------------------------------
	"goolord/alpha-nvim", -- startup menu
	"embear/vim-localvimrc", -- .lvimrc support
	"janko-m/vim-test",   -- generic test runner
	{                     -- nightly minimal completion engine
		"echasnovski/mini.nvim",
		config = function()
			require("mini.comment").setup({
				-- map commenting to ctrl-c, helix-style
				mappings = { comment = "<C-c>", comment_line = "<C-c>", comment_visual = "<C-c>" },
			})
			require("mini.statusline").setup({})
			require("mini.tabline").setup({})
		end,
	},
	{
		"ms-jpq/coq_nvim",
		config = function()
			vim.g.coq_settings = { auto_start = "shut-up" }
			local coq = require("coq")
			local lspconfig = require("lspconfig")
			lspconfig.util.on_setup = lspconfig.util.add_hook_before(lspconfig.util.on_setup,
				function(config)
					local cap = coq.lsp_ensure_capabilities(config)
					config.capabilities = cap.capabilities
				end)
		end,
	},

	-- Syntax
	----------------------------------------
	"knatsakis/deb.vim", -- support for xz
	"dbeniamine/todo.txt-vim",
	"folke/trouble.nvim",
	"nvim-treesitter/nvim-treesitter",
	"nvim-treesitter/nvim-treesitter-textobjects",
	"windwp/nvim-ts-autotag", -- auto close tags using ts

	-- Edition
	----------------------------------------
	"tpope/vim-sleuth", -- auto shiftwidth
	{
		"matze/vim-move", -- alt-arrow line moving
		config = function()
			-- Default binds are prone to accidental moves.
			vim.g.move_map_keys = 0
			vim.cmd("vmap <A-j> <Plug>MoveBlockDown")
			vim.cmd("vmap <A-k> <Plug>MoveBlockUp")
		end,
	},
	"jqno/jqno-extractvariable.vim",
	"tpope/vim-surround",
	{
		"windwp/nvim-autopairs", -- autoclose pairs
		config = function()
			require("nvim-autopairs").setup({
				check_ts = true,
			})
		end,
	},

	-- Tooling
	----------------------------------------
	{
		"nvim-telescope/telescope.nvim", -- like fzf, but lua
		config = function()
			require("telescope").setup({
				defaults = {
					-- no_ignore_parent = true,
					mappings = {
						i = {
							["<esc>"] = require("telescope.actions").close,
						},
					},
				},
			})
		end,
	},
	"tpope/vim-obsession",      -- auto session management
	"tpope/vim-fugitive",       -- git commands
	"junkblocker/patchreview-vim", -- side-by-side diff viewer
	"mbbill/undotree",          -- visual undo tree
	"kopischke/vim-fetch",      -- file:line remapper
	{
		"kyazdani42/nvim-tree.lua", -- file tree
		lazy = false,
		opts = {
			actions = {
				open_file = {
					quit_on_open = true,
				},
			},
			view = {
				width = 30,
			},
			filters = {
				dotfiles = true,
			},
		},
	},
	"liuchengxu/vista.vim", -- taglist panel, with lsp support
	"romainl/vim-cool",  -- auto-toggle hls
}
-- vim: ts=4
