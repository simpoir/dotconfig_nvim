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
Plug 'mhinz/vim-signify'                  " like gitgutter for all
Plug 'tpope/vim-fugitive'                 " git
Plug 'liuchengxu/vim-which-key'           " the backslash menu

"
" Coding
"
Plug 'mhinz/vim-startify'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'  " check perf

Plug 'embear/vim-localvimrc'
Plug 'janko-m/vim-test'
Plug 'Vimjas/vim-python-pep8-indent'

"
" Syntax
"
Plug 'knatsakis/deb.vim'                  " support for xz
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
" Plug 'tmsvg/pear-tree'     " bad perf
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'psf/black', { 'branch': 'stable' }

"
" Tooling
"
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-obsession'
Plug 'mhinz/vim-grepper'
Plug 'airblade/vim-rooter'
Plug 'junkblocker/patchreview-vim'
Plug 'sjl/gundo.vim'
Plug 'kopischke/vim-fetch'
Plug 'scrooloose/nerdtree'
cal plug#end()

"
" New vim packs
"
packadd termdebug
let g:termdebug_wide=1
let g:termdebugger="rust-gdb"


"
" Look and feel
"
set termguicolors
au BufRead * set cursorline
colo space-vim-dark
" colo molokai
hi clear SpellBad
hi SpellBad cterm=underline ctermfg=168 ctermbg=9 gui=undercurl guisp=Red
hi LspDiagnosticsUnderlineError cterm=bold ctermfg=160 ctermbg=235 guifg=normal gui=undercurl guisp=#e0211d
hi LspDiagnosticsUnderlineWarning cterm=bold ctermfg=136 guifg=normal gui=undercurl guisp=#dc752f
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
" LSP
"
let g:lsp_log_file=''
func! s:lsp_reg(lang, cmd)
  if executable(a:cmd[0])
    cal lsp#register_server({
          \ 'name': a:lang,
          \ 'cmd': {server_info->a:cmd},
          \ 'allowlist': [a:lang],
          \})
  endif
endf
cal s:lsp_reg('python', ['pyls'])
cal s:lsp_reg('go', ['gopls'])
cal s:lsp_reg('vim', ['vim-language-server', '--stdio'])
cal s:lsp_reg('sh', ['bash-language-server', 'start'])
cal s:lsp_reg('rust', ['rust-analyzer'])
set omnifunc=lsp#complete
set signcolumn=yes

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
cal which_key#register("Leader", "g:lmap")
nnoremap <silent> <leader> :<c-u>WhichKey "Leader"<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual "Leader"<CR>
let g:lmap = {'name': 'Global',
  \'c': {'name': 'Cursor',
    \'b': [':!xdg-open https://pad.lv/<cword>', 'Launchpad Bug'],
  \},
  \'d': {'name': 'Debug',
    \'b': [':Break', 'Break'],
    \'d': [':Termdebug', 'Debug'],
    \'c': [':Clear', 'Clear breakpoint'],
    \},
  \'f': {'name': 'Files',
    \'a': ['Alternate()', 'jump to Alternate file.'],
    \'d': [':e $MYVIMRC', 'Open dotfile'],
    \'f': ["fzf#vim#files('', fzf#vim#with_preview({'source': 'rg --files'}), 0)", 'Find file'],
    \'g': [":Grepper -tool rg", 'Grep'],
    \},
  \'l': {'name': 'Language',
    \'d': ["LspDefinition", 'Definition'],
    \'e': ["LspDocumentDiagnostics", 'Errors'],
    \'n': ["LspNextDiagnostic", 'Next Error'],
    \'p': ["LspPrevDiagnostic", 'Prev Error'],
    \'f': ["LspDocumentFormat", "format"],
    \'h': ["LspHover", "hover"],
    \'i': ["LspImplementation", 'Implementation'],
    \'q': ["LspCodeActionSync", 'Quick-fix'],
    \'r': ["LspRename", 'Rename symbol']
    \},
  \'t': {'name': 'Test',
    \'f': [':TestFile', 'Test file'],
    \'l': [':TestLast', 'Retest last'],
    \'n': [':TestNearest', 'Test nearest'],
    \},
  \}

augroup autoformat
  au!
  au BufWritePre *.rs LspDocumentFormatSync
augroup END

set completeopt=menuone,noselect,noinsert
set shortmess+=c

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

let g:black_linelength = 79
let g:bl_pagefiletypes = ['html', 'javascript', 'markdown', 'liquid', 'scss']

command! EmailAddr call fzf#run({'source': 'cat ~/.mail/staff', 'sink': {choice -> append(line('.'), choice)}})

" Human autocorrect
command! W w

command! WriteAsRoot %!env SUDO_ASKPASS='/usr/bin/ssh-askpass' sudo -A tee %

func! Alternate()
  if &filetype == 'python'
    let l:alt=matchlist(expand('%:p'), '^\(.*/\)tests/test_\(.*\.py\)$')
    if empty(l:alt)
      edit %:h/tests/test_%:t
    else
      exe 'edit ' . fnameescape(l:alt[1] . l:alt[2])
    endif
  elseif &filetype == 'go'
    if match(expand('%:p'), '_test.go$') != -1
      exe 'edit ' . fnameescape(substitute(expand('%:p'), '_test.go$', '.go', ''))
    else
      exe 'edit ' . fnameescape(substitute(expand('%:p'), '.go$', '_test.go', ''))
    endif
  endif
endf

autocmd BufNewFile,BufRead /tmp/user/*/neomutt*,/tmp/user/*/aerc-* set noautoindent tw=78 filetype=mail spell
