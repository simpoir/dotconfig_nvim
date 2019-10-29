call plug#begin('~/.config/nvim/plugged')

"
" Appearance
"
Plug 'flazz/vim-colorschemes'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mhinz/vim-signify'  " like gitgutter for all

"
" Coding
"
Plug 'mhinz/vim-startify'
Plug 'valloric/youcompleteme'
Plug 'shougo/denite.nvim'
Plug 'w0rp/ale'
Plug 'embear/vim-localvimrc'
Plug 'janko-m/vim-test'
Plug 'craigemery/vim-autotag'

"
" Syntax
"
Plug 'knatsakis/deb.vim'  " support for xz
Plug 'kana/vim-textobj-user'
Plug 'bps/vim-textobj-python'


"
" Edition
"
Plug 'ciaranm/detectindent'
Plug 'matze/vim-move'

"
" Tooling
"
Plug 'tpope/vim-obsession'
Plug 'yegappan/grep'

cal plug#end()


" look and feel
"
set termguicolors
colo gruvbox
set mouse=
set number
set list
set colorcolumn=80
let g:airline_powerline_fonts = 1
let g:ale_sign_error = "🔥"
let g:ale_sign_warning = "⚠"
let g:iwilldiffer_check_on_open=1
let g:iwilldiffer_check_on_save=1
let g:iwilldiffer_has_hg=0

" Tooling
"
let g:localvimrc_persistent = 1
let g:localvimrc_name = ['.lvimrc', '_vimrc_local.vim']


" Human autocorrect
command! W tabnew term://sl ++close

" Edition
"
autocmd BufReadPost * DetectIndent
set autoindent
set smartindent

" denite
" Define mappings
nnoremap <c-space> :Denite -start-filter -matchers=matcher/substring source<CR>
nnoremap <c-p> :Denite -start-filter -matchers=matcher/substring file/rec<CR>
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
        \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
        \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
        \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
        \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
        \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
        \ denite#do_map('toggle_select').'j'
endfunction


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


" open vimrc
nmap <silent> <leader>fd :e $MYVIMRC<CR>
