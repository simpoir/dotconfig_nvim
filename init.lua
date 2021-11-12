-- ==================================================
-- Simpoir's unfriendly but convenient nvim config
--
-- For Neovim 0.5.0+
--
-- Copyright (c) 2019-2021 Simon Poirier
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

----------------------------------------
-- Bootstrap Site Packs
----------------------------------------
local install_path = fn.stdpath("config") .. "/site/"
opt.packpath:append(install_path)

----------------------------------------
-- Packages
----------------------------------------
local packs = {
  -- Appearance
  ----------------------------------------
  'flazz/vim-colorschemes';
  'vim-airline/vim-airline';
  'vim-airline/vim-airline-themes';
  'mhinz/vim-signify';                 -- like gitgutter for all
  'liuchengxu/vim-which-key';          -- the backslash menu
  'justincampbell/vim-eighties';       -- auto 80col resizer

  -- Coding
  ----------------------------------------
  'mhinz/vim-startify';
  'neovim/nvim-lspconfig';             -- common configs for LSP
  -- Plug 'dense-analysis/ale';                 -- static analyzer
  -- Plug 'rhysd/vim-lsp-ale';
  'embear/vim-localvimrc';             -- .lvimrc support
  'janko-m/vim-test';                  -- generic test runner
  'Vimjas/vim-python-pep8-indent';

  -- Syntax
  ----------------------------------------
  'knatsakis/deb.vim';                 -- support for xz
  'kana/vim-textobj-user';
  'bps/vim-textobj-python';
  'saltstack/salt-vim';
  'Glench/Vim-Jinja2-Syntax';
  'dbeniamine/todo.txt-vim';
  'dag/vim-fish';
  'maxmellon/vim-jsx-pretty';

  -- Edition
  ----------------------------------------
  'tpope/vim-sleuth';                  -- auto shiftwidth
  'matze/vim-move';                    -- alt-arrow line moving
  'fvictorio/vim-extract-variable';
  'tpope/vim-surround';
  'tpope/vim-commentary';
  'psf/black';
  'fisadev/vim-isort';

  -- Tooling
  ----------------------------------------
  --{'junegunn/fzf',  'dir': '~/.fzf', 'do': './install --all' };
  --'junegunn/fzf.vim';
  'tpope/vim-obsession';               -- auto session management
  'mhinz/vim-grepper';                 -- ag/rg/grep generic grepper
  'airblade/vim-rooter';               -- autochdir to repo
  'junkblocker/patchreview-vim';       -- side-by-side diff viewer
  'mbbill/undotree';                   -- visual undo tree
  'kopischke/vim-fetch';               -- file:line remapper
}
-- tiny package manager
local breadcrumbs = fn.readdir(install_path.."pack/simpoir/opt")
for i, p in pairs(packs) do
  p = string.gsub(p, "^[^/]+/", "")
  -- lazy-ish loader
  if #(fn.readdir(install_path.."pack/simpoir/opt/"..p)) == 0 then
    print("["..i.."/"..#packs.."] Pulling submodule pack for "..p)
    fn.system({"git", "-C", fn.stdpath("config"), "submodule", "update", "--init", "site/pack/simpoir/opt/"..p})
  end
  cmd("redrawstatus")
  print("loading pack "..p)
  cmd("packadd "..p)
  for k, v in pairs(breadcrumbs) do
    if v == p then table.remove(breadcrumbs, k) end
  end
end
cmd "helptags ALL"
if #breadcrumbs > 0 then
  local msg = "leftover packs: "
  for _, v in pairs(breadcrumbs) do
    msg = msg .. v .. " "
  end
  print(msg)
else
  cmd("redraw")
  print("Happy vimming!")
end

-- local optional packs
vim.cmd "packadd termdebug"
g.termdebug_wide = 1
g.termdebuger = "rust-gdb"


----------------------------------------
-- Look and feel
----------------------------------------

g.startify_custom_header = {
  '                                          ,ggg,         ,gg                     ',
  '                                         dP""Y8a       ,8P                      ',
  '                                         Yb, `88       d8"                      ',
  '                                          `"  88       88gg                     ',
  '                                              88       88""                     ',
  '            ,ggg,,ggg,    ,ggg,     ,ggggg,   I8       8Igg    ,ggg,,ggg,,ggg,  ',
  '           ,8" "8P" "8,  i8" "8i   dP"  "Y8ggg`8,     ,8"88   ,8" "8P" "8P" "8, ',
  '           "8   8I   8I  I8, ,8I  i8"    ,8I   Y8,   ,8P 88   I8   8I   8I   8I ',
  '                8I   Yb, `YbadP" ,d8,   ,d8"    Yb,_,dP_,88,_,dP   8I   8I   Yb,',
  '                8I   `Y8888P"Y888P"Y8888P"       "Y8P" 8P""Y88P:   8I   8I   `Y8',
}
g.startify_bookmarks = {}
g.startify_change_to_vcs_root = 1
g.startify_lists = {
  { type = 'sessions',  header = {'   Sessions'}           },
  { type = 'bookmarks', header = {'   Bookmarks'}          },
  { type = 'dir',       header = {'   MRU '.. fn.getcwd()} },
  { type = 'commands',  header = {'   Commands'}           },
}

cmd "colo space-vim-dark"
cmd "au BufRead * set cursorline"

g.neovide_cursor_vfx_mode = "railgun"
g.neovide_refresh_rate = 20
g.airline_powerline_fonts = 1

opt.colorcolumn = "80"
opt.guifont = "FuraCode Nerd Font Mono:h10"
opt.list = true
opt.mouse = ""
opt.number = true
opt.termguicolors = true

----------------------------------------
-- Tooling
----------------------------------------
g.localvimrc_persistent = 1
g.localvimrc_name = {".lvimrc", "_vimrc_local.vim"}
g.rooter_change_directory_for_non_project_files = "current" -- soothes LSP in home dir
g.signify_vcs_cmds = {bzr = "bzr diff --diff-options=-U0 -- %f"}

----------------------------------------
-- LSP
----------------------------------------
local lspconfig = require("lspconfig")

lspconfig.ltex.setup {
  cmd = { os.getenv("HOME").."/opt/ltex-ls-15.1.0/bin/ltex-ls" };
  filetypes = { "markdown", "rst", "tex", "mail" };
  single_file_support = true;
}

lspconfig.yamlls.setup{
  cmd = { "node", os.getenv("HOME").."/node_modules/.bin/yaml-language-server", "--stdio" },
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = { schemas = {
      ["https://ghcdn.rawgit.org/techhat/openrecipeformat/master/schema.json"] = "*.orf.yml",
    } },
  }
}

lspconfig.pylsp.setup{
  cmd = { "pyls" }
}

lspconfig.rust_analyzer.setup{
  settings = { ['rust-analyzer'] = { checkOnSave= { command= 'clippy' } } }
}
lspconfig.vimls.setup{
  cmd = {"node", os.getenv("HOME").."/node_modules/.bin/vim-language-server", "--stdio"}
}

opt.omnifunc = "v:lua.vim.lsp.omnifunc"
opt.signcolumn = "yes"

----------------------------------------
-- Edition
----------------------------------------
opt.autoindent = true
opt.smartindent = true

----------------------------------------
-- Pretty Mappings
----------------------------------------
fn["which_key#register"]("Leader", "g:lmap")
vim.api.nvim_set_keymap("n", "<leader>", "<cmd>WhichKey 'Leader'<CR>", {noremap=true, silent=true})
vim.api.nvim_set_keymap("v", "<leader>", "<cmd>WhichKeyVisual 'Leader'<CR>", {noremap=true, silent=true})
g.lmap = {
  name = 'Global',
  c = {
    name = 'Cursor',
    b = {':!xdg-open https://pad.lv/<cword>', 'Launchpad Bug'},
  },
  d = {
    name = 'Debug',
    b = {':Break', 'Break'},
    d = {':Termdebug', 'Debug'},
    c = {':Clear', 'Clear breakpoint'}
  },
  f = {
    name = 'Files',
    a = {'v:lua.Alternate()', 'jump to Alternate file.'},
    d = {':e $MYVIMRC', 'Open dotfile'},
    f = {"fzf#vim#files('', fzf#vim#with_preview({'source': 'rg --files'}), 0)", 'Find file'},
    g = {":Grepper -tool rg", 'Grep'},
  },
  l = {
    name = 'Language',
    d = {"luaeval('vim.lsp.buf.definition()')", 'Definition'},
    f = {"luaeval('vim.lsp.buf.formatting()')", "format"},
    e = {"luaeval('vim.lsp.diagnostic.set_qflist()')", "Diagnostics"},
    h = {"luaeval('vim.lsp.buf.hover()')", "hover"},
    i = {"luaeval('vim.lsp.buf.implementation()')", 'Implementation'},
    q = {"luaeval('vim.lsp.buf.code_action()')", 'Quick-fix'},
    r = {"luaeval('vim.lsp.buf.rename()')", 'Rename symbol'},
    R = {"luaeval('vim.lsp.buf.references()')", 'Find References'}
  },
  t = {
    name = 'Test',
    f = {':TestFile', 'Test file'},
    l = {':TestLast', 'Retest last'},
    n = {':TestNearest', 'Test nearest'},
  },
}


vim.api.nvim_set_keymap("i", "rpudb", "<cmd>cal setline(line('.'), getline(line('.')).'import pudb.remote; pudb.remote.set_trace(term_size=('.&columns.', '.(&lines-1).'))')<CR>", {noremap=true})
vim.api.nvim_set_keymap("i", "pudb", "import pudb; pudb.set_trace()", {noremap=true})

cmd [[
augroup autoformat
au!
au BufWritePre *.rs lua vim.lsp.buf.formatting()
au BufWritePre *.go lua vim.lsp.buf.formatting()
augroup END
]]

function Alternate()
  local filetype = vim.api.nvim_buf_get_option(0, "filetype")
  if filetype == 'python' then
    local alt = fn.matchlist(fn.expand('%:p'), [[^\(.*/\)tests/test_\(.*\.py\)$]])
    if #alt == 0 then
      cmd("edit " .. fn.expand("%:h") .. "/tests/test_" .. fn.expand("%:t"))
    else
      cmd("edit " .. fn.fnameescape(alt[2] .. alt[3]))
    end
  elseif filetype == 'go' then
    if fn.match(fn.expand('%:p'), '_test.go$') ~= -1 then
      cmd("edit "..fn.fnameescape(fn.substitute(fn.expand('%:p'), '_test.go$', '.go', '')))
    else
      fmd("edit "..fn.fnameescape(fn.substitute(fn.expand('%:p'), '.go$', '_test.go', '')))
    end
  else
    print("no defined alt for this filetype: ".. filetype);
  end
end
