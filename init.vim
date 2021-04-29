call plug#begin('~/.vim/plugged')

Plug 'fatih/vim-go'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'chriskempson/base16-vim'
Plug 'sheerun/vim-polyglot'
Plug 'christoomey/vim-tmux-navigator'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'justinmk/vim-dirvish'
" Initialize plugin system
call plug#end()




let mapleader="\<Space>"
let maplocalleader="\\"

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Airline theme
let g:airline_theme='base16_ocean'



" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif


function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')


" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

let $NVIM_TUI_ENABLE_TRUE_COLOR=1
" set backgound=dark
colorscheme base16-ocean
set termguicolors

command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)


" Run FZF based on the cwd & git detection
" 1. Runs :Files, If cwd is not a git repository
" 2. Runs :GitFiles <cwd> If root is a git repository
fun! FzfOmniFiles()
  " Throws v:shell_error if is not a git directory
  let git_status = system('git status')
  if v:shell_error != 0
    :Files
  else
    " Reference examples which made this happen:
    " https://github.com/junegunn/fzf.vim/blob/master/doc/fzf-vim.txt#L209
    " https://github.com/junegunn/fzf.vim/blob/master/doc/fzf-vim.txt#L290
    " --exclude-standard - Respect gitignore
    " --others - Show untracked git files
    " dir: getcwd() - Shows file names relative to cwd
    let git_files_cmd = ":GitFiles --exclude-standard --cached --others"
    call fzf#vim#gitfiles('--exclude-standard --cached --others', {'dir': getcwd(), 'options': ['--layout=reverse', '--info=inline', '--preview', '~/.vim/plugged/fzf.vim/bin/preview.sh {}']})
  endif
endfun
" }}}

nnoremap <silent> <C-p> :call FzfOmniFiles()<CR>
nnoremap <silent> <C-c> :Commands<CR>

nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l
nnoremap <C-h> <C-W>h


set splitbelow
set splitright

set number

set shiftwidth=2
set tabstop=2


let g:coc_global_extensions = [ 'coc-tsserver' ]


" Send more characters for redraws
set ttyfast
" Enable mouse use in all modes
set mouse=a

let g:prettier#quickfix_enabled = 0
let g:prettier#autoformat_require_pragma = 0
let g:prettier#autoformat = 1

set foldmethod=manual   
set foldlevelstart=99               " start unfolded



" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction


autocmd! BufWritePost $MYVIMRC source $MYVIMRC | echom "Reloaded $NVIMRC"


" Leader mappings.

" <Leader><Leader> -- Open last buffer.
nnoremap <Leader><Leader> <C-^>
nnoremap <Leader>q :quit<CR>
nnoremap <Leader>w :write<CR>
nnoremap <Leader>x :xit<CR>

"Coc Symbol renaming.
nmap <Leader>rn <Plug>(coc-rename)

" Mappings for CoCList
" Show commands.
nnoremap <silent><nowait> <Leader>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <Leader>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <Leader>s  :<C-u>CocList -I symbols<cr>


set number relativenumber

autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
