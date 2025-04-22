runtime! debian.vim

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif


"--------------------------------------------------------------------------- 
" General Settings
"--------------------------------------------------------------------------- 

set nocompatible                            " not compatible with the old-fashion vi mode
set bs=2                                    " allow backspacing over everything in insert mode 
                                               "(讓 backspace 可以刪除換行、自動產生的縮排還有在進入該次 insert mode 之前打的字)
set history=50                              " keep 50 lines of command line history
set autoread                                " auto read when file is changed from outside
set mouse=r                                 " Enable mouse usage (all modes)
                                                " mouse=a =>按住 Shift 後，在用滑鼠選取，可以使用 Ctrl + c 複製，或此時用滑鼠中間就可以貼上。
                                                    " (再按一下 Shift 選取反白才會消失)
                                                " :set mouse= 或 :set mouse=r 或 :set mouse=v (設定不要為 a 就可以使用標準系統的選取、複製模式)
set ai                                      " auto indent
set shiftwidth=4                            " auto indent width=4 space
set expandtab                               " convert tab to space, width is depend on `tabstop`
set tabstop=4                               " tab width shown as 4 space
set hlsearch                                " search highlighting
set ignorecase                              " ignore case when searching
set smartcase                               " ignore case if search pattern is all lowercase,case-sensitive otherwise
set smarttab                                " insert tabs on the start of a line according to context
set clipboard^=unnamed,unnamedplus          " make the * and + registers both point to the system clipboard
set encoding=utf-8                          " Set encoding of vim

filetype off          " necessary to make ftdetect work on Linux
filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins
au BufReadPre * setlocal foldmethod=indent    " Indent folding with manual folds




"---------------------------------------------------------------------------
" PROGRAMMING SETTINGS
"---------------------------------------------------------------------------

" @@@@@@@@@@@@@@@@@@@ Enable omni completion. (Ctrl-X Ctrl-O) @@@@@@@@@@@@@@@@@@@
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType c set omnifunc=ccomplete#Complete
autocmd FileType java set omnifunc=javacomplete#Complete
" @@@@@@@@@@@@@@@@@@@ Enable omni completion. (Ctrl-X Ctrl-O) @@@@@@@@@@@@@@@@@@@

" @@@@@@@@@@@@@@@@@@@ use syntax complete if nothing else available @@@@@@@@@@@@@@@@@@@
if has("autocmd") && exists("+omnifunc")
  autocmd Filetype *
              \	if &omnifunc == "" |
              \		setlocal omnifunc=syntaxcomplete#Complete |
              \	endif
endif
" @@@@@@@@@@@@@@@@@@@ use syntax complete if nothing else available @@@@@@@@@@@@@@@@@@@

" @@@@@@@@@@@@@@@@@@@ auto sort order of imported module python script
if executable("isort")
    autocmd BufWritePost *.py :!isort %
endif
" @@@@@@@@@@@@@@@@@@@ auto sort order of imported module python script

"--------------------------------------------------------------------------- 
" vim plug
"--------------------------------------------------------------------------- 

call plug#begin()
Plug '~/.vim/plugged/dracula'
Plug '~/.vim/plugged/ale'
Plug '~/.vim/plugged/tagbar'
Plug '~/.vim/plugged/vim-airline'
Plug '~/.vim/plugged/vim-airline-themes'
Plug '~/.vim/plugged/git-lens'  " git-lens.vim fit to Vim 9.0 and upper, For older Vim, you might want to use zivyangll / git-blame.vim (https://github.com/zivyangll/git-blame.vim)
Plug '~/.vim/plugged/copilot'  " `copilot.vim`: Download zip from https://github.com/github/copilot.vim, Unzip and Rename the directory to `copilot`, then Move it to `~/.vim/plugged`
call plug#end()


"--------------------------------------------------------------------------- 
" custom settings for pluging
"--------------------------------------------------------------------------- 

" @@@@@@@@@@@@@@@@@@@ cscope custom settings@@@@@@@@@@@@@@@@@@@
" setting base location of code index (ctags, cscope)
let CODE_IDX_DIR=expand("~/code_index")  " You can update this directory if you need
let PROJECT_ROOT=expand(matchstr(expand('%:p'), '^/workspace/codes/[^/]\+'))  " You can update this directory if you need

" setting location of cscope db & cscopetag
let CSCOPE_DB_DIR=CODE_IDX_DIR .. "/cscope_index"
let CSCOPE_DB_SRC=CSCOPE_DB_DIR .. "/cscope.files"
let CSCOPE_DB=CSCOPE_DB_DIR .. "/cscope.out"

if !isdirectory(CSCOPE_DB_DIR)
    call mkdir(CSCOPE_DB_DIR, "p")
endif

func UpdateCscopeDB(channel, msg)
    if has("cscope")
    "   set csprg=/usr/local/bin/cscope
        set csto=0
        set cst
        set nocsverb
        set nocscopeverbose
        " add database in CSCOPE_DB
        if g:['CSCOPE_DB'] != ""
            exe "cs add" g:['CSCOPE_DB']
        " add database pointed to by environment
        else
            exe "cs add" $CSCOPE_DB
        endif
        set csverb
    endif
endfunc

" based on different filetype to create cscope.files
if executable("cscope") && PROJECT_ROOT!=""
    if !filereadable(CSCOPE_DB)
        echom "Not Detect " .. CSCOPE_DB .. ", so start to create cscope.file, cscope.out!!!!!!"
        let create_cscope_db_cmd=" | xargs realpath > " .. CSCOPE_DB_SRC .. "; " .. "cd " .. CSCOPE_DB_DIR .. "; " .. "cscope -Rbq -i " .. CSCOPE_DB_SRC
        autocmd BufRead,BufNewFile *.py  let job_cscope = job_start(["/bin/sh", "-c", "find " .. PROJECT_ROOT .. " -name \"*.py\" -not -path \"*__pycache__/*\" -not -path \"*.ipynb_checkpoints*\"" .. create_cscope_db_cmd], {"exit_cb": "UpdateCscopeDB"})
        autocmd BufRead,BufNewFile *.java let job_cscope = job_start(["/bin/sh", "-c", "find " .. PROJECT_ROOT .. " -name \"*.java\"" .. create_cscope_db_cmd], {"exit_cb": "UpdateCscopeDB"})
        autocmd BufRead,BufNewFile *.c let job_cscope = job_start(["/bin/sh", "-c", "find " .. PROJECT_ROOT .. " -name \"*.c\" -o -name \"*.h\"" .. create_cscope_db_cmd], {"exit_cb": "UpdateCscopeDB"})
        autocmd BufRead,BufNewFile *.cpp let job_cscpoe = job_start(["/bin/sh", "-c", "find " .. PROJECT_ROOT .. " -name \"*.cpp\" -o -name \"*.hpp\" -o -name \"*.h\"" .. create_cscope_db_cmd], {"exit_cb": "UpdateCscopeDB"})
        autocmd BufRead,BufNewFile *.hpp let job_cscope = job_start(["/bin/sh", "-c", "find " .. PROJECT_ROOT .. " -name \"*.cpp\" -o -name \"*.hpp\" -o -name \"*.h\"" .. create_cscope_db_cmd], {"exit_cb": "UpdateCscopeDB"})
    else
        echom "If you want to update cscopeDB, please delete " .. CSCOPE_DB
        let job_cscope = job_start(["/bin/sh", "-c", "echo 'cscope.out exist in" .. CSCOPE_DB .. "'"], {"exit_cb": "UpdateCscopeDB"})
    endif
endif
" @@@@@@@@@@@@@@@@@@@ cscope custom settings @@@@@@@@@@@@@@@@@@@

" @@@@@@@@@@@@@@@@@@@ ctags custom settings @@@@@@@@@@@@@@@@@@@
" setting location of tag file of ctags
let CTAGS_TAG_DIR=CODE_IDX_DIR .. "/ctags_index"
let CTAGS_TAG=CTAGS_TAG_DIR .. "/tags"

if !isdirectory(CTAGS_TAG_DIR)
    call mkdir(CTAGS_TAG_DIR, "p")
endif

if executable("ctags") && PROJECT_ROOT!=""
    if !filereadable(CTAGS_TAG)
        echom "Not Detect " .. CTAGS_TAG .. ", so start to create tags!!!!!!"
        autocmd BufReadPost * silent execute "!ctags -R --python-kinds=-i --languages=Python --extra=+qf --fields=+nt --exclude=\"*__pycache__*\" --exclude=\"*ipynb_checkpoints*\" --exclude=\"*.json\" --exclude=\"*ipynb*\" -f " .. CTAGS_TAG .. " " .. PROJECT_ROOT
        let &tags .= ',' . CTAGS_TAG
    else
        echom "If you want to update ctags tags, please delete " .. CTAGS_TAG
        let &tags .= ',' . CTAGS_TAG
    endif
endif
" @@@@@@@@@@@@@@@@@@@ ctags custom settings @@@@@@@@@@@@@@@@@@@

" @@@@@@@@@@@@@@@@@@@ ale custom settings @@@@@@@@@@@@@@@@@@@
let g:ale_linters = {
\   'python': ['flake8', 'pylint'],
\}

" ref: - https://vi.stackexchange.com/questions/30855/pylint-default-filepath-in-ale
"      - https://github.com/dense-analysis/ale/blob/06f57ca9733aab6e6b67015917fdfd4bf1c70c48/doc/ale-python.txt#L594
let g:ale_python_pylint_options = '--rcfile '.expand('~/.config/lint_config/.pylintrc')
let g:ale_python_flake8_options = '--config='.expand('~/.config/lint_config/.flake8')
let g:ale_virtualtext_cursor = 0
" @@@@@@@@@@@@@@@@@@@ ale custom settings @@@@@@@@@@@@@@@@@@@

" @@@@@@@@@@@@@@@@@@@ git-lens custom settings @@@@@@@@@@@@@@@@@@@
" ref: - https://github.com/Eliot00/git-lens.vim
let g:GIT_LENS_ENABLED=v:true  " make plugin git-lens defaultly enabled

" git-blame.vim(For older vim, alternative of git-lens)
"     ref: - https://github.com/zivyangll/git-blame.vim
" @@@@@@@@@@@@@@@@@@@ git-lens custom settings @@@@@@@@@@@@@@@@@@@

"--------------------------------------------------------------------------- 
" Outlook Settings
"--------------------------------------------------------------------------- 

colorscheme dracula                         " set vim scheme by plugin `dracula/vim`

if has("syntax")                            " turn on syntax highlight
  syntax on
endif

set t_Co=256                                " number of colors that Vim will use
set ruler                                   " show the cursor position all the time
set showcmd                                 " Show (partial) command in status line.
set showmode                                " Show current mode
set showmatch                               " Show matching brackets.
set nu                                      " show line number
set cursorline                              " auto hightlight cursor line

" @@@@@@@@@@@@@@@@@@@ set cursor shape ref: https://www.youtube.com/watch?v=FcQjTXLrVUU&ab_channel=NickJanetakis @@@@@@@@@@@@@@@@@@@
" Reference chart of values:
" 0 -> blinking block
" 1 -> blinking block (default)
" 2 -> steady block
" 3 -> blinking underline
" 4 -> steady  underline
" 5 -> blinking bar (xterm)
" 6 -> steady bar (xterm)
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
" @@@@@@@@@@@@@@@@@@@ set cursor shape ref: https://www.youtube.com/watch?v=FcQjTXLrVUU&ab_channel=NickJanetakis @@@@@@@@@@@@@@@@@@@

" @@@@@@@@@@@@@@@@@@@ display invisible characters @@@@@@@@@@@@@@@@@@@
set list                                    " Display invisible characters
set listchars=eol:↵,tab:⇥⇥,trail:⎵,
highlight Invisible ctermfg=4
match Invisible /\s/
2match Invisible /\n/
" @@@@@@@@@@@@@@@@@@@ display invisible characters @@@@@@@@@@@@@@@@@@@

" @@@@@@@@@@@@@@@@@@@ display name of class and function for vim-airline @@@@@@@@@@@@@@@@@@@
let g:airline_theme='dracula'
let g:airline#extensions#tagbar#flags = 'f'  " ref: https://superuser.com/questions/279651/how-can-i-make-vim-show-the-current-class-and-method-im-editing#answer-1148549
" @@@@@@@@@@@@@@@@@@@ display name of class and function for vim-airline @@@@@@@@@@@@@@@@@@@

"---------------------------------------------------------------------------
" USEFUL SHORTCUTS
"---------------------------------------------------------------------------

" set leader to ,
let mapleader=","
let g:mapleader=","

" 在insert-mode下，只要輸入 ( ，vim會先執行輸入 () → <Esc> 進入 Command-mode → i 進入 Insert-mode → 就會發現游標在 “(” “)” 之間(i(o了
" 其他同理
inoremap ( ()<Esc>i
inoremap " ""<Esc>i
inoremap ' ''<Esc>i
inoremap [ []<Esc>i
" 在 insert-mode 時，當輸入 { → <CR>，vim會輸入 { → <CR> 換行 → 輸入 } → 進入command-mode → k 光標上移 → o 插入新的一行 → 自動增加縮排
inoremap {<CR> {<CR>}<Esc>ko
inoremap {{ {}<ESC>i

" jj to leave insert mode
inoremap jj <ESC>

" ,/ turn off search highlighting
nmap <leader>/ :nohl<CR>
" if is edit .py files=> ,c will save files and execute .py
autocmd BufRead *.py nmap<leader>c :w<Esc>G:r!python3 %<CR>`.

" @@@@@@@@@@@@@@@@@@@ move around splits @@@@@@@@@@@@@@@@@@@
" move to and maximize the below split
map <C-j> <C-w>j<C-w>_
" move to and maximize the above split
map <C-k> <C-w>k<C-w>_
" move to and maximize the left split
nmap <C-h> <C-w>h<C-w><bar>
" move to and maximize the right split
nmap <C-l> <C-w>l<C-w><bar>
set wmw=0                     " set the min width of a window to 0 so we can maximize others 
set wmh=0                   " set the min height of a window to 0 so we can maximize others
" @@@@@@@@@@@@@@@@@@@ move around splits @@@@@@@@@@@@@@@@@@@

" @@@@@@@@@@@@@@@@@@@ tagbar key maps @@@@@@@@@@@@@@@@@@@
nmap <F8> :TagbarToggle<CR>
" @@@@@@@@@@@@@@@@@@@ tagbar key maps @@@@@@@@@@@@@@@@@@@

" @@@@@@@@@@@@@@@@@@@ cscope key maps @@@@@@@@@@@@@@@@@@@

if has("cscope")
    " 'CTRL-\' : To do the first type of search
    "            - followed by one of the cscope search types:(s, g, c, t, e, f, i, d)
    " 'CTRL-T' : Go back to where you were before the search.

    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>	
    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>	


    " Using 'CTRL-spacebar' (intepreted as CTRL-@ by vim) then a search type
    " makes the vim window split horizontally, with search result displayed in
    " the new window.
    "
    " (Note: earlier versions of vim may not have the :scs command, but it
    " can be simulated roughly via:
    "    nmap <C-@>s <C-W><C-S> :cs find s <C-R>=expand("<cword>")<CR><CR>	

    nmap <C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>	
    nmap <C-@>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>	
    nmap <C-@>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>	


    " Hitting CTRL-space *twice* before the search type does a vertical 
    " split instead of a horizontal one (vim 6 and up only)
    "
    " (Note: you may wish to put a 'set splitright' in your .vimrc
    " if you prefer the new window on the right instead of the left

    nmap <C-@><C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>	
    nmap <C-@><C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>	
    nmap <C-@><C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>
endif
" @@@@@@@@@@@@@@@@@@@ cscope key maps @@@@@@@@@@@@@@@@@@@


"--------------------------------------------------------------------------- 
" Deprecated SHORTCUTS
"--------------------------------------------------------------------------- 

" new tab
"map <C-t><C-t> :tabnew<CR>
" close tab
"map <C-t><C-w> :tabclose<CR> 


"--------------------------------------------------------------------------- 
" Deprecated outlook settings
"--------------------------------------------------------------------------- 
"colorscheme monokai  " Put monokai.vim file in your ~/.vim/colors/ directory and add the following line to your ~/.vimrc
"set background=dark  " If want to using a dark background within the editing area and syntax highlighting, turn on this option

" @@@@@@@@@@@@@@@@@ status line @@@@@@@@@@@@@@@
"set laststatus=2
"set statusline=\ %{HasPaste()}%<%-15.25(%f%)%m%r%h\ %w\ \
"set statusline+=%1*\[%n]                                      "buffernr
"set statusline+=%3*\ %=\ %{''.(&fenc!=''?&fenc:&enc).''}\       "Encoding
"set statusline+=%4*\ %{(&bomb?\",BOM\":\"\")}\                  "Encoding2
"set statusline+=\ \ \ %<%20.30(%{hostname()}:%{CurDir()}%)\
"set statusline+=%=%10.(%l,%c%V%)\ %p%%/%L

"function! CurDir()
"    let curdir = substitute(getcwd(), $HOME, "~", "")
"    return curdir
"endfunction

"function! HasPaste()
"    if &paste
"        return '[PASTE]'
"    else
"        return ''
"    endif
"endfunction
" @@@@@@@@@@@@@@@@@ status line @@@@@@@@@@@@@@@


"--------------------------------------------------------------------------- 
" Deprecated function
"--------------------------------------------------------------------------- 
"au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif  " Uncomment the following to have Vim jump to the last position when reopening a file

" The following are commented out as they cause vim to behave a lot differently from regular Vi. They are highly recommended though.
"set incsearch		" Incremental search
"set autowrite		" Automatically save before commands like :next and :make
"set hidden		" Hide buffers when they are abandoned



"--------------------------------------------------------------------------- 
" Deprecated vim-plug
"--------------------------------------------------------------------------- 
"Plug 'fisadev/vim-isort'  " Just call the ``:Isort`` command, and it will reorder the imports of the current python file. (https://vimawesome.com/plugin/vim-isort)


