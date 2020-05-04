" ==================================================
" Simpoir's unfriendly but convenient nvim config
"
" Neovim 0.5.0 (nightly) is required at the moment.
"
" Copyright (c) 2019-2020 Simon Poirier
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice (including the next
" paragraph) shall be included in all copies or substantial portions of the
" Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
" SOFTWARE.
" ==================================================
call plug#begin('~/.config/nvim/plugged')

"
" Appearance
"
Plug 'flazz/vim-colorschemes'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mhinz/vim-signify'  " like gitgutter for all
Plug 'tpope/vim-fugitive'
Plug 'damofthemoon/vim-leader-mapper'
Plug 'ryanoasis/vim-devicons'

"
" Coding
"
Plug 'mhinz/vim-startify'
"Plug 'valloric/youcompleteme'  " replaced by nvim-lsp
Plug 'neovim/nvim-lsp'
"Plug 'w0rp/ale'  " replaced by nvim-lsp
Plug 'embear/vim-localvimrc'
Plug 'janko-m/vim-test'
Plug 'craigemery/vim-autotag'
Plug 'Vimjas/vim-python-pep8-indent'

"
" Syntax
"
Plug 'knatsakis/deb.vim'  " support for xz
Plug 'kana/vim-textobj-user'
Plug 'bps/vim-textobj-python'
Plug 'saltstack/salt-vim'
Plug 'Glench/Vim-Jinja2-Syntax'

"
" Edition
"
Plug 'tpope/vim-sleuth'
Plug 'matze/vim-move'
Plug 'fvictorio/vim-extract-variable'
" Plug 'jiangmiao/auto-pairs'  " more annoying than it is worth
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'

"
" Tooling
"
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-obsession'
Plug 'mhinz/vim-grepper'
Plug 'airblade/vim-rooter'
Plug 'junkblocker/patchreview-vim'
Plug 'jaxbot/browserlink.vim'
Plug 'sjl/gundo.vim'

cal plug#end()


"
" Look and feel
"
set termguicolors
colo space-vim-dark
set mouse=
set number
set list
set colorcolumn=80
let g:airline_powerline_fonts = 1

"
" Tooling
"
let g:localvimrc_persistent = 1
let g:localvimrc_name = ['.lvimrc', '_vimrc_local.vim']

"
" Edition
"
set autoindent
set smartindent

let g:startify_custom_header = [
      \ '                                          ,ggg,         ,gg                     ',
      \ '                                         dP""Y8a       ,8P                      ',
      \ '                                         Yb, `88       d8"                      ',
      \ '                                          `"  88       88gg                     ',
      \ '                                              88       88""                     ',
      \ '            ,ggg,,ggg,    ,ggg,     ,ggggg,   I8       8Igg    ,ggg,,ggg,,ggg,  ',
      \ '           ,8" "8P" "8,  i8" "8i   dP"  "Y8ggg`8,     ,8"88   ,8" "8P" "8P" "8, ',
      \ '           "8   8I   8I  I8, ,8I  i8"    ,8I   Y8,   ,8P 88   I8   8I   8I   8I ',
      \ '                8I   Yb, `YbadP" ,d8,   ,d8"    Yb,_,dP_,88,_,dP   8I   8I   Yb,',
      \ '                8I   `Y8888P"Y888P"Y8888P"       "Y8P" 8P""Y88P:   8I   8I   `Y8',
      \ ]
let g:startify_change_to_vcs_root = 1
let g:startify_bookmarks = [ '~/Source/canonical/landscape-client/master/', '~/Source/canonical/landscape/trunk/' ]
let g:startify_lists = [
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ ]


"
" Mappings
"
nnoremap <silent> <leader> :cal leaderMapper#start() "<Space>"<CR>
vnoremap <silent> <leader> :cal leaderMapper#start() "<Space>"<CR>
let g:leaderMenu = {'name': 'Global',
  \'f': [{'name': 'Files',
    \'d': [':e $MYVIMRC', 'Open dotfile'],
    \'f': [":cal fzf#vim#files('', fzf#vim#with_preview({'source': 'rg --files'}), 0)", 'Find file'],
    \'g': [":Grepper -tool rg", 'Grep'],
    \}, 'Files'],
  \'l': [{'name': 'LSP',
    \'d': [":lua require'vim.lsp.buf'.definition()", 'Definition'],
    \'e': [":lua require'vim.lsp.util'.show_line_diagnostics()", 'Line Error'],
    \'f': [":lua require'vim.lsp.buf'.formatting()", "format"],
    \'h': [":lua require'vim.lsp.buf'.hover()", "hover"],
    \}, 'LSP'],
  \'t': [{'name': 'Test',
    \'f': [':TestFile', 'Test file'],
    \'l': [':TestLast', 'Retest last'],
    \'n': [':TestNearest', 'Test nearest'],
    \}, 'Tests'],
  \}

"
" LSP
"
lua <<EOF
  lsp = require'nvim_lsp'
  lsp.pyls.setup{}
  lsp.rust_analyzer.setup{}
  lsp.gopls.setup{}
  lsp.vimls.setup{}
  lsp.clangd.setup{}

  -- publish diags to quickfix
  do
    local method = 'textDocument/publishDiagnostics'
    local default_callback = vim.lsp.callbacks[method]
    vim.lsp.callbacks[method] = function(err, method, result, client_id)
      default_callback(err, method, result, client_id)
      if result and result.diagnostics then
        for _, v in ipairs(result.diagnostics) do
          v.uri = v.uri or result.uri
          v.filename = v.uri
          v.lnum = v.range.start.line + 1
          v.col = v.range.start.character + 1
          v.text = v.message
        end
        vim.lsp.util.set_qflist(result.diagnostics)
      end
    end
  end
EOF
set completefunc=v:lua.vim.lsp.omnifunc

"
" Utility
"
func! ReloadVim()
  tabnew
  source $MYVIMRC
  PlugInstall
  packloadall
endf
command! ReloadVim call ReloadVim()

" <3 python debug
inoremap rpudb ;<bs><esc>:cal setline(line("."), getline(line("."))."import pudb.remote; pudb.remote.set_trace(term_size=(".&columns.", ".&lines."))")<cr><cr>
inoremap pudb import pudb; pudb.set_trace()

let g:bl_pagefiletypes = ['html', 'javascript', 'markdown', 'liquid', 'scss']

command! EmailAddr call fzf#run({'source': 'cat ~/.mail/staff', 'sink': {choice -> append(line('.'), choice)}})

" Human autocorrect
command! W w

command! WriteAsRoot %!sudo tee %
