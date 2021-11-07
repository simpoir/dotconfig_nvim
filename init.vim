" ==================================================
" Simpoir's unfriendly but convenient nvim config
"
" For Neovim 0.5.0+
"
" Copyright (c) 2019-2021 Simon Poirier
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
Plug 'justincampbell/vim-eighties'

"
" Coding
"
Plug 'mhinz/vim-startify'
Plug 'dense-analysis/ale'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'rhysd/vim-lsp-ale'
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
Plug 'dbeniamine/todo.txt-vim'
Plug 'dag/vim-fish'
Plug 'maxmellon/vim-jsx-pretty'

"
" Edition
"
Plug 'tpope/vim-sleuth'
Plug 'matze/vim-move'
Plug 'fvictorio/vim-extract-variable'
" Plug 'tmsvg/pear-tree'     " bad perf
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'psf/black', { 'tag': '19.10b0' }
Plug 'fisadev/vim-isort'

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
Plug 'jceb/vim-orgmode'
cal plug#end()

" Fixes bad plugins assuming bash shell.
set shell=/bin/bash

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
set guifont=FuraCode\ Nerd\ Font\ Mono:h10
let g:neovide_cursor_vfx_mode = "railgun"
let g:neovide_refresh_rate=20
au BufRead * set cursorline
colo space-vim-dark
" colo molokai
hi clear SpellBad
hi SpellBad cterm=underline ctermfg=168 ctermbg=9 gui=undercurl guisp=Red
hi LanguageToolGrammarError cterm=underline ctermfg=168 ctermbg=9 gui=undercurl guisp=#00af00
hi LspErrorHighlight cterm=bold ctermfg=160 ctermbg=235 guifg=normal gui=undercurl guisp=#e0211d
hi LspWarningHighlight cterm=bold ctermfg=136 guifg=normal gui=undercurl guisp=#dc752f
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
let g:ale_linters = {'mail': ['vale']}
let g:signify_vcs_cmds = {
\ "bzr": 'brz diff --diff-options=-U0 -- %f',
\ }
" avoid LSP going crazy when running in home
let g:rooter_change_directory_for_non_project_files = 'current'

"
" LSP
"
" let g:lsp_log_file=''
let g:lsp_settings = {
\  'yaml-language-server': {
\    'workspace_config': {
\      'yaml': {
\        'schemas': {
\          'https://ghcdn.rawgit.org/techhat/openrecipeformat/master/schema.json': '*.orf.yml'
\        },
\        'completion': v:true,
\        'hover': v:true,
\        'validate': v:true,
\      }
\    }
\  },
\  'rust-analyzer': {
\    'workspace_config': {
\      'rust-analyzer': { 'checkOnSave': { 'command': 'clippy' } }
\    }
\  },
\}

set omnifunc=lsp#complete
set signcolumn=yes
let g:lsp_virtual_text_prefix = " ‣ "

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
let g:startify_bookmarks = []
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
\  'c': {'name': 'Cursor',
\    'b': [':!xdg-open https://pad.lv/<cword>', 'Launchpad Bug'],
\  },
\  'd': {'name': 'Debug',
\    'b': [':Break', 'Break'],
\    'd': [':Termdebug', 'Debug'],
\    'c': [':Clear', 'Clear breakpoint'],
\    },
\  'f': {'name': 'Files',
\    'a': ['Alternate()', 'jump to Alternate file.'],
\    'd': [':e $MYVIMRC', 'Open dotfile'],
\    'f': ["fzf#vim#files('', fzf#vim#with_preview({'source': 'rg --files'}), 0)", 'Find file'],
\    'g': [":Grepper -tool rg", 'Grep'],
\    },
\  'l': {'name': 'Language',
\    'd': ["LspDefinition", 'Definition'],
\    'e': ["LspDocumentDiagnostics", 'Errors'],
\    'n': ["LspNextDiagnostic", 'Next Error'],
\    'p': ["LspPrevDiagnostic", 'Prev Error'],
\    'f': ["LspDocumentFormat", "format"],
\    'h': ["LspHover", "hover"],
\    'i': ["LspImplementation", 'Implementation'],
\    'q': ["LspCodeActionSync", 'Quick-fix'],
\    'r': ["LspRename", 'Rename symbol'],
\    'R': ["LspReferences", 'Find References']
\    },
\  't': {'name': 'Test',
\    'f': [':TestFile', 'Test file'],
\    'l': [':TestLast', 'Retest last'],
\    'n': [':TestNearest', 'Test nearest'],
\    },
\  }

augroup autoformat
  au!
  au BufWritePre *.rs LspDocumentFormatSync
  au BufWritePre *.go LspDocumentFormatSync
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
inoremap rpudb ;<bs><esc>:cal setline(line("."), getline(line("."))."import pudb.remote; pudb.remote.set_trace(term_size=(".&columns.", ".(&lines-1)."))")<cr><cr>
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

autocmd BufNewFile,BufRead $TEMP/{neomutt,aerc-,meli,qutebrowser-editor-}* set noautoindent tw=78 filetype=mail spell
autocmd BufWritePost $TEMP/{neomutt,aerc-,meli,qutebrowser-editor-}* LanguageToolCheck

" todo
augroup todotxt
  au!
  au filetype todo setlocal omnifunc=todo#Complete
  au filetype todo imap <buffer> + +<C-X><C-O>
  au filetype todo imap <buffer> @ @<C-X><C-O>
  au filetype todo setlocal completeopt+=menuone
augroup END

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 et indentkeys-=0# indentkeys-=<:> foldmethod=indent nofoldenable
autocmd FileType javascriptreact setlocal ts=4 sts=4 sw=4 et
