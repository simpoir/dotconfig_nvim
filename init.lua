-- ==================================================
-- Simpoir's unfriendly but convenient nvim config
--
-- For Neovim 0.8.0+
--
-- Copyright (c) 2019-2024 Simon Poirier
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to
-- deal in the Software without restriction, including without limitation the
-- rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
-- sell copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice (including the next
-- paragraph) shall be included in all copies or substantial portions of the
-- Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
-- FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
-- IN THE SOFTWARE.
-- ==================================================

local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local opt = vim.opt

require("config.lazy")

-- compat
opt.shell = "/bin/bash"
-- termsync induces some glitches pasting/deleting multiple lines with multi
-- windows on wezterm with mux.
-- opt.termsync = false

----------------------------------------
-- Look and feel
----------------------------------------
-- merge w. global clipboard
opt.clipboard = "unnamedplus"

g.Todo_fold_char = ""

-- avoid switching to subdirs when opening project files.
opt.autochdir = false

opt.scrolloff = 5 -- scroll margin
require("simpoir.ui").setup({
	-- theme = "paramount",
	-- theme = "Tomorrow-Night",
	-- theme = "randomhue",
	-- theme = "monokai-phoenix",
	-- theme = "minimalist",
	theme = "monokai",
})

-- Override all themes to make cursor visible (blink) in paren matching
vim.api.nvim_set_hl(0, "MatchParen", { bg = "red", fg = "cyan" })
g.eighties_bufname_additional_patterns = { "fugitiveblame", "NvimTree", "__vista__" }

vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		g.pyindent_open_paren = 4
	end,
})
-- autoclose tree with last buffer
vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("", { clear = true }),
	nested = true,
	callback = function()
		cmd("if winnr('$') == 1 && bufname() == 'NvimTree_'.tabpagenr() | quit | endif")
	end,
})

opt.updatetime = 200 -- time between keystrokes which is considered idle.
g.indentLine_char = "┊"
-- hide markup bits (e.g. json quotes) except on hover
g.conceal_level = 0
g.indentLine_concealcursor = "c"

----------------------------------------
-- Tooling
----------------------------------------
g.signify_vcs_cmds = { bzr = "bzr diff --diff-options=-U0 -- %f" }


----------------------------------------
-- LSP
----------------------------------------
g.lsp_formatters_disabled = { "pylsp" }
function FilteredFormat()
	if vim.lsp.buf.format ~= nil then
		vim.lsp.buf.format({
			filter = function(client)
				for _, v in ipairs(g.lsp_formatters_disabled) do
					if v == client.name then
						return false
					end
				end
				return true
			end,
		})
	else
		-- nvim 7 fallback
		vim.lsp.buf.formatting_sync()
	end
end

require("mason").setup()
local lspconfig = require("lspconfig")
lspconfig.yamlls.setup({
	settings = {
		redhat = { telemetry = { enabled = false } },
		yaml = {
			schemas = {
				["https://cdn.jsdelivr.net/gh/techhat/openrecipeformat/schema.json"] = "*.orf.yml",
				["https://cdn.jsdelivr.net/gh/cappyzawa/concourse-pipeline-jsonschema@v6.5.0/concourse_jsonschema.json"] =
				"pipeline.yml",
				["/home/simpoir/Source/scratchpad/jjb.schema"] = "jenkins/**/*",
				["https://raw.githubusercontent.com/canonical/cloud-init/main/cloudinit/config/schemas/schema-cloud-config-v1.json"] =
				"*.cloud",
			},
			customTags = {
				"!j2:",
				"!include:",
				"!include-jinja2:",
				"!include-raw-escape:",
				"!include-jinja2:",
				"!include-jinja2: sequence",
			},
		},
	},
})
lspconfig.bashls.setup({
	filetypes = { "sh", "bash", "shjinja" },
})
lspconfig.jinja_lsp.setup({
	filetyles = { "htmldjango" },
})
vim.api.nvim_create_autocmd("BufRead", {
	pattern = { "templates/**/*.html" },
	callback = function()
		opt.syntax = "htmldjango"
		opt.filetyle = "htmldjango"
	end,
})

lspconfig.rust_analyzer.setup({
	settings = {
		["rust-analyzer"] = {
			checkOnSave = { command = "clippy" },
			autoimport = { enable = true },
		}
	},
})
local lua_libs = vim.api.nvim_get_runtime_file("", true)
table.insert(lua_libs, "/usr/share/awesome/lib")
lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = lua_libs,
				maxPreload = 10000,
				preloadFileSize = 10000,
				checkThirdParty = false,
			},
			telemetry = { enable = false },
			hint = { enable = true },
		},
	},
})
lspconfig.pylsp.setup({
	cmd = { "/usr/bin/pylsp" },
	settings = {
		pylsp = {
			plugins = {
				pycodestyle = {
					-- ignore = { "W391" },
					maxLineLength = 120,
				},
			},
		},
	},
})
lspconfig.basedpyright.setup({
	settings = {
		basedpyright = {
			analysis = {
				diagnosticSeverityOverrides = {
					reportUnknownVariableType = "none",
					reportUnknownMemberType = "none",
					reportAny = "none",
					reportUnusedCallResult = "none",
					reportPrivateImportUsage = "none",
					reportAssignmentType = "none",
				}
			}
		}
	}
})

-- auto setup other installed servers
for _, srv in ipairs(require("mason-lspconfig").get_installed_servers()) do
	local loaded = lspconfig.util.available_servers()
	if not vim.tbl_contains(loaded, srv) then
		lspconfig[srv].setup({})
	end
end
lspconfig.ltex.setup({
	filetypes = { "bib", "gitcommit", "markdown", "org", "text", "plaintex", "rst", "rnoweb", "tex", "pandoc", "mail" },
})

-- non-lsp lang bits
opt.tabstop = 2

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	virtual_text = false, -- provided by diagflow
	underline = true,
	signs = true,
})

----------------------------------------
-- Pretty Mappings
----------------------------------------
local whichkey = require("which-key")
whichkey.add({
	{ "<Space>c", group = "Cursor" },
	{ "<Space>cb", "<cmd>!xdg-open https://pad.lv/<cword><cr>", desc = "Launchpad Bug" },

	{ "<Space>d", group = "Debug" },
	{ "<Space>db", require "dap".toggle_breakpoint, desc = "Break" },
	{ "<Space>dn", require "dap".step_over, desc = "Next" },
	{ "<Space>dx", require "dap".repl.open, desc = "Eval" },
	{ "<Space>ds", require "dap.ui.widgets".sidebar(require "dap.ui.widgets".scopes).open, desc = "Scopes" },
	{ "<Space>dc", require "dap".continue, desc = "Continue" },
	{ "<Space>dt", function() DbgRustTests() end, desc = "Debug tests" },

	{ "<Space>f", group = "Files" },
	{ "<Space>fa", function() Alternate() end, desc = "jump to Alternate file." },
	{ "<Space>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffer" },
	{ "<Space>fc", function() BufGone() end, desc = "Close buffer and switch to next" },
	{ "<Space>fd", "<cmd>e $MYVIMRC<cr>", desc = "Open dotfile" },
	{ "<Space>fp", function() cmd("Explore " .. vim.fs.dirname(vim.fn.getenv("MYVIMRC")) .. "/lua/plugins/") end, desc = "Open plugins" },
	{ "<Space>ff", "<cmd>Telescope find_files<cr>", desc = "Find file" },
	{ "<Space>fF", "<cmd>Telescope git_files<cr>", desc = "Repository find" },
	{ "<Space>fj", "<cmd>Telescope jumplist<cr>", desc = "Jump list" },
	{ "<Space>fG", function() TelescopeSel() end, desc = "Grep selection", mode = 'nv' },
	{ "<Space>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
	{ "<Space>ft", "<cmd>NvimTreeFindFile<cr>", desc = "file Tree toggle" },

	{ "<Space>g", group = "Git" },
	{ "<Space>gs", "<cmd>Git<cr>", desc = "status" },
	{ "<Space>gb", "<cmd>Git blame<cr>", desc = "blame" },
	{ "<Space>gc", "<cmd>Git commit<cr>", desc = "commit" },
	{ "<Space>gl", "<cmd>Git log --graph --decorate<cr>", desc = "log" },

	{ "<Space>l", group = "Language", icon = "  " },
	{ "<Space>la", vim.lsp.buf.code_action, desc = "Actions" },
	{ "<Space>ld", vim.lsp.buf.definition, desc = "Definition" },
	{ "<Space>lD", vim.lsp.buf.type_definition, desc = "Type definition" },
	{ "<Space>lf", function() FilteredFormat() end, desc = "Format file" },
	{ "<Space>le", function() require 'trouble'.toggle { mode = 'diagnostics' } end, desc = "Diagnostics" },
	{ "<Space>lh", vim.lsp.buf.hover, desc = "hover" },
	{ "<Space>lH", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, desc = "Toggle Hints" },
	{ "<Space>li", vim.lsp.buf.implementation, desc = "Implementation" },
	{ "<Space>lI", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
	{ "<Space>lr", vim.lsp.buf.rename, desc = "Rename symbol" },
	{ "<Space>lR", vim.lsp.buf.references, desc = "Find References" },
	{ "<Space>lS", "<cmd>Mason<cr>", desc = "Install" },

	{ "<Space>t", group = "Test" },
	{ "<Space>tf", "<cmd>TestFile<cr>", desc = "Test file" },
	{ "<Space>tl", "<cmd>TestLast<cr>", desc = "Retest last" },
	{ "<Space>tn", "<cmd>TestNearest<cr>", desc = "Test nearest" },
})
vim.api.nvim_set_keymap("v", "<Space>ev", "<Plug>(extractVariableVisual)", { noremap = true, silent = true })

vim.api.nvim_set_keymap(
	"i",
	"rpudb",
	"<cmd>cal setline(line('.'), getline(line('.')).'import pudb.remote; pudb.remote.set_trace(term_size=('.&columns.', '.(&lines-1).'))')<CR>",
	{ noremap = true }
)
vim.api.nvim_set_keymap("i", "pudb", "import pudb; pudb.set_trace()", { noremap = true, desc = "quick pdb" })
vim.api.nvim_set_keymap("i", "{<cr>", "{<cr>}<esc>O", { noremap = true, desc = "Auto-curly" })

-- format on save for a select few types
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.go", "*.rs", "*.lua", "*.js" },
	callback = FilteredFormat,
})
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = { "*.qml" },
	callback = function()
		opt.filetype = "qmljs"
	end,
})
cmd([[
augroup autoformat
au!
" autoformat emails
au BufRead *.eml set fo+=anw tw=76
command! WriteAsRoot %!env SUDO_ASKPASS=/usr/bin/ssh-askpass sudo tee %
augroup END
]])

function TelescopeSel()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
	local prefill
	local a = vim.fn.getpos("'<")
	local b = vim.fn.getpos("'>")
	prefill = vim.fn.getregion(a, b, { type = 'v' })[1]
	-- some escaping
	prefill = prefill:gsub("{", "\\{")
	require 'telescope.builtin'.live_grep { default_text = prefill }
end

function Alternate()
	local filetype = vim.api.nvim_get_option_value("filetype", { scope = "local" })
	if filetype == "python" then
		local alt = fn.matchlist(fn.expand("%:p"), [[^\(.*/\)tests/test_\(.*\.py\)$]])
		if #alt == 0 then
			cmd("edit " .. fn.expand("%:h") .. "/tests/test_" .. fn.expand("%:t"))
		else
			cmd("edit " .. fn.fnameescape(alt[2] .. alt[3]))
		end
	elseif filetype == "cpp" then
		if fn.expand("%:e") == "h" then
			cmd("edit %:r.cpp")
		else
			cmd("edit %:r.h")
		end
	elseif filetype == "go" then
		if fn.match(fn.expand("%:p"), "_test.go$") ~= -1 then
			cmd("edit " .. fn.fnameescape(fn.substitute(fn.expand("%:p"), "_test.go$", ".go", "")))
		else
			cmd("edit " .. fn.fnameescape(fn.substitute(fn.expand("%:p"), ".go$", "_test.go", "")))
		end
	else
		print("no defined alt for this filetype: " .. filetype)
	end
end

function BufGone()
	cmd("bn")
	cmd("bd#")
end

function DbgRustTests()
	local dap = require("dap")
	local tgt = fn.system({
		"sh",
		"-c",
		"cargo build -q --tests --message-format=json|jq -r 'select(.executable).executable'",
	}):gsub("\n$", "")
	local modname = fn.expand("%:r"):gsub("/", "::"):gsub("^src::", "")
	dap.configurations.rust[1].program = tgt
	dap.configurations.rust[1].args = { "--nocapture", modname }
	dap.continue()
end

cmd("command! DbgRustTests lua DbgRustTests()")

local dap = require("dap")
dap.defaults.fallback.force_external_terminal = true
dap.defaults.fallback.external_terminal = {
	command = "/usr/bin/gnome-terminal",
	args = { "--" },
}
dap.adapters.lldb = {
	type = "executable",
	command = "/usr/bin/lldb-vscode-14",
	name = "lldb",
}
dap.adapters.cppdbg = {
	type = "executable",
	command = fn.environ().HOME .. "/.local/share/nvim/mason/bin/OpenDebugAD7",
	args = { "--trace" },
	name = "cppdbg",
	id = "cppdbg", -- PSA don't change this.
}
dap.configurations.c = {
	{
		name = "Launch gdb",
		type = "cppdbg",
		request = "launch",
		MIMode = "gdb",
		program = function()
			g.program = vim.fn.input({
				prompt = "Path to executable: ",
				text = g.program or "",
				completion =
				"file"
			})
			return g.program
		end,
		cwd = "${workspaceFolder}",
	},
}
dap.configurations.rust = {
	{
		name = "Launch",
		type = "cppdbg",
		request = "launch",
		MIMode = "gdb",
		miDebuggerPath = fn.environ().HOME .. "/.cargo/bin/rust-gdb",
		program = function()
			return vim.fn.input({
				prompt = "Path to executable: ",
				text = vim.fn.getcwd() .. "/",
				completion =
				"file"
			})
		end,
		cwd = "${workspaceFolder}",
		args = {},
	},
}
vim.api.nvim_set_keymap("", "<F5>", "<cmd>lua require 'dap'.step_into()<CR>", { noremap = true })
vim.api.nvim_set_keymap("", "<F6>", "<cmd>lua require 'dap'.step_over()<CR>", { noremap = true })
vim.api.nvim_set_keymap("i", "<F6>", "<cmd>lua require 'dap'.step_over()<CR>", { noremap = true })
vim.api.nvim_set_keymap("", "<F7>", "<cmd>lua require 'dap'.continue()<CR>", { noremap = true })
vim.api.nvim_set_keymap("", "<F8>", "<cmd>lua require 'dap'.toggle_breakpoint()<CR>", { noremap = true })
require("nvim-dap-virtual-text").setup({})

require("nvim-treesitter.configs").setup({
	modules = {},
	ignore_install = {},
	ensure_installed = { "c", "lua", "python", "rust" },
	-- take precedence over builtins
	parser_install_dir = fn.stdpath("data") .. "/site",
	sync_install = false,
	auto_install = true,
	autopairs = {
		enable = true,
	},
	autotag = {
		enable = true,
		filetypes = { "html", "xml", "htmldjango" },
	},
	highlight = {
		enable = true,
	},
	indent = {
		enable = true,
		-- syntax-based indent wasn't an option with indent-scoped formats
		-- It's getting better. If it breaks again, disable the filetypes
		disable = { "rust" }, -- https://github.com/nvim-treesitter/nvim-treesitter/issues/5615
	},
	textobjects = {
		select = {
			enable = true,

			-- Automatically jump forward to textobj, similar to targets.vim
			lookahead = true,

			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				-- you can optionally set descriptions to the mappings (used in the desc parameter of nvim_buf_set_keymap
				["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
				["aa"] = "@parameter.outer",
			},

			-- You can choose the select mode (default is charwise 'v')
			selection_modes = {
				["@parameter.outer"] = "v", -- charwise
				["@function.outer"] = "V", -- linewise
				["@class.outer"] = "<c-v>", -- blockwise
			},
			-- If you set this to `true` (default is `false`) then any textobject is
			-- extended to include preceding xor succeeding whitespace. Succeeding
			-- whitespace has priority in order to act similarly to eg the built-in
			-- `ap`.
			-- include_surrounding_whitespace = true,
		},
	},
	move = {
		enable = true,
		goto_next_start = {
			["]m"] = { "@function.outer", "@class.outer" },
		},
	},
})
-- fixes autoclose tags with django.
vim.treesitter.language.register("htmldjango", "html")

-- hack in bash+django
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = { "*.j2" },
	callback = function()
		vim.treesitter.language.register("htmldjango", "shjinja")
		vim.treesitter.query.set(
			"htmldjango",
			"injections",
			'((content) @injection.content (#set! injection.language "bash") (#set! injection.combined))'
		)
		cmd("set filetype=shjinja")
	end,
})

----------------------------------------
-- Helix zone.
-- Here are bits which I liked trying out Helix.
----------------------------------------

vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", {})
vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.type_definition()<cr>", {})
vim.api.nvim_set_keymap("n", "ge", "<cmd>Telescope diagnostics<cr>", {})
vim.api.nvim_set_keymap(
	"n",
	"gne",
	"<cmd>lua vim.diagnostic.goto_next()<cr>",
	{ noremap = true, silent = true, desc = "next error" }
)
vim.api.nvim_set_keymap(
	"n",
	"<C-q>",
	"<cmd>lua vim.lsp.buf.code_action({apply=true, filter=function(a) return a.isPreferred end})<cr>",
	{ noremap = true, silent = true, desc = "quickfix" }
)

-- Helix-style syntactic incremental selection. Alt-i Alt-o
VisualNode = {}
function VisualBlockNode(pop)
	if pop then
		if #VisualNode then
			VisualNode[#VisualNode] = nil
		end
		if #VisualNode then
			VisualNode[#VisualNode] = nil
		end
	end
	if vim.fn.mode() == "v" and #VisualNode > 0 then
		VisualNode[#VisualNode + 1] = VisualNode[#VisualNode]:parent()
		vim.cmd("normal! v")
	else
		VisualNode = { vim.treesitter.get_node() }
	end
	if not VisualNode[#VisualNode] then
		return
	end
	local node = VisualNode[#VisualNode]
	if node == nil then
		return
	end
	local start_l, start_c = node:start()
	local end_l, end_c = node:end_()
	vim.fn.cursor(start_l + 1, start_c + 1)
	vim.cmd("normal! v")
	vim.fn.cursor(end_l + 1, end_c)
end

vim.api.nvim_set_keymap("v", "<A-o>", "<cmd>lua VisualBlockNode()<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-o>", "<cmd>lua VisualBlockNode()<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<A-i>", "<cmd>lua VisualBlockNode(true)<cr>", { noremap = true, silent = true })
function VisualBlockSiblingNode(prev)
	if vim.fn.mode() ~= "v" or #VisualNode == 0 then
		VisualNode = { vim.treesitter.get_node() }
	else
		vim.cmd("normal! v")
	end
	local node
	if prev then
		node = VisualNode[#VisualNode]:prev_sibling()
	else
		node = VisualNode[#VisualNode]:next_sibling()
	end

	if node == nil then
		return
	end

	VisualNode = { node }
	local start_l, start_c = node:start()
	local end_l, end_c = node:end_()
	vim.fn.cursor(start_l + 1, start_c + 1)
	vim.cmd("normal! v")
	vim.fn.cursor(end_l + 1, end_c)
end

vim.api.nvim_set_keymap("v", "<A-n>", "<cmd>lua VisualBlockSiblingNode()<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-n>", "<cmd>lua VisualBlockSiblingNode()<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<A-p>", "<cmd>lua VisualBlockSiblingNode(true)<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<A-p>", "<cmd>lua VisualBlockSiblingNode(true)<cr>", { noremap = true, silent = true })

-- shift-k already was used for showing manpages. Hijack to show any LSP documentation.
vim.api.nvim_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-s>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", { noremap = true, silent = true })
-- jump between start and end of visual selection. Also mimics helix.
vim.api.nvim_set_keymap("v", "<A-;>", "o", {})

-- Auto unload buffers to external files.
function CleanBufs()
	local here = vim.fn.getcwd()
	for _, b in ipairs(vim.api.nvim_list_bufs()) do
		local name = vim.api.nvim_buf_get_name(b)
		local first_char = name:sub(1, 1)
		if (first_char == "/" or first_char == "~") and name:sub(1, here:len()) ~= here then
			vim.api.nvim_buf_delete(b, {})
		end
	end
end

cmd([[command! CleanBufs lua CleanBufs()]])
-- vim: ts=4
