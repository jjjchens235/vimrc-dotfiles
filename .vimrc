"###############################################################
" Basic Settings
"###############################################################

set lines=65
"set columns=80
set autoindent
set number
set ignorecase
set smartcase
set relativenumber
set nocompatible
set foldcolumn=1
set showcmd
set noswapfile
" Sets how many lines of history VIM has to remember
set history=500
syntax on
syntax enable
let mapleader = ","

set splitbelow splitright

" Disable the default Vim startup message.
set shortmess+=I
set backspace=indent,eol,start

"finding files/buffers -------
set path=.,**
set autochdir
set hidden
set wildmenu
" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win32unix") || has("win32")
		set wildignore+=.git\*,.hg\*,.svn\*
else
		set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" copy buffer file name, https://stackoverflow.com/a/17096082 
if has("gui_gtk") || has("gui_gtk2") || has("gui_gnome") || has("unix")
	" filename (foo.txt)
	nnoremap <leader>cf :let @+=expand("%:t")<CR>
	" absolute path (/something/src/foo.txt)
	nnoremap <leader>cF :let @+=expand("%:p")<CR>
endif

"colors ------------
let g:solarized_termcolors=256
let g:solarized_termtrans=1
let g:solarized_italic=0
set t_Co=16 "t_Co=16 makes terminal vim background lighter
set background=dark
try
		colorscheme solarized
catch /^Vim\%((\a\+)\)\=:E185/
		colorscheme slate
endtry
"fixes vim terminal background scrolling issue
if !has("gui_running")
		set term=screen-256color
endif
"line number coloring
highlight LineNr ctermfg=248 ctermbg=23 guifg=#586e75 guibg=#073642

set hlsearch
hi Search guibg=White guifg=Purple
nnoremap <esc><esc> :silent! nohls<CR>

"blinking cursor
let &t_EI = "\<Esc>[1 q"
let &t_SR = "\<Esc>[3 q"
let &t_SI = "\<Esc>[5 q"

"------- file types
set encoding=utf-8
set ffs=unix,dos,mac
autocmd FileType * set tabstop=2|set shiftwidth=2|set noexpandtab
autocmd FileType python set tabstop=4|set shiftwidth=4|set expandtab|set noignorecase
autocmd BufRead,BufNewFile *.md set tabstop=4
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType crontab setlocal nowritebackup
autocmd FileType sql set noai|set tabstop=2|set expandtab

" No annoying sound on errors
set belloff=all
set noerrorbells
set novisualbell
set t_vb=
set tm=500
if has("gui_macvim")
		autocmd GUIEnter * set vb t_vb=
endif

"###############################################################
" MAPPINGS
"###############################################################

" -------------------------------------------------------------------------
" General Mappings
" -------------------------------------------------------------------------
nnoremap <leader>w :w<CR>:redraw!<CR>
nnoremap <leader>we :w<CR> :sleep<CR> :e<CR>
 
" Remap VIM 0 to first non-blank character
nmap 0 ^
"
"yank from cursor till end of line, similiar to C and D
noremap Y y$
"
"go to last non-blank char
nmap $ g_
vmap $ g_
 
" toggle highlighting the cursor line
nnoremap <leader>, :set cursorline!<CR>

" Q in normal mode enters Ex mode. You almost never want this
nmap Q <Nop>
"
"re-map ctr v visual block since we re-mapped ctr+v to paste
nnoremap <leader>v <C-v>
"redraw/repaint the screen
nnoremap <leader>r :redraw!<CR>

" ------------------------- Windows and Terminal --------------------------
nnoremap <leader>vs :vs<CR>

" Smart way to move between windows
noremap <C-j> <C-W>j
noremap <C-k> <C-W>k
noremap <C-h> <C-W>h
noremap <C-l> <C-W>l
" move between windows and :term
tnoremap <c-j> <c-w>j
tnoremap <c-k> <c-w>k
tnoremap <c-l> <c-w>l
tnoremap <c-h> <c-w>h

"resize to max-height - 15
tnoremap <C-w>m <C-W>j <C-W>15_ <C-W>k 
nnoremap <C-w>m <C-W>j <C-W>15_ <C-W>k 

"maximize current split without closing other split
tnoremap <C-w>M <C-W>_
nnoremap <C-w>M <C-W>_
"make split smallest as possible
tnoremap <C-w>0 <C-W>1_
nnoremap <C-w>0 <C-W>1_

" normal mode for :term window, save ctr-n for fzf in terminal mode
tnoremap <leader>n <C-W>Nzb

"open/re-open terminal as horizontal split
nnoremap <expr> <leader>tt Is_term_exist() ? '<C-w>o :botright sb \!/usr/local/bin/bash<Tab><CR><C-W>15_<C-w>k':':botright term<CR><C-W>15_'
"open/re-open terminal as vertical split
nnoremap <expr> <leader>tv Is_term_exist() ? '<C-w>o :topleft 55vsp\|buffer \!/usr/local/bin/bash<Tab><CR>':':vert term<CR><C-w>R<C-w>15>'
"open new terminal, might be useful if a terminal is already open but an extra one
nnoremap <leader>tn :botright term<CR><C-W>15_

"Past terminal window mappings ...

"Re-open existing terminal as split
nmap <leader>te :botright sb \!/usr/local/bin/bash<Tab><CR><C-W>15_
"term reset- make current buffer only one and then open existing terminal
"nnoremap <leader>tr <C-w>o :botright sb \!/bin/bash<Tab><CR><C-W>15_<C-w>k
"maybe deprecate tr if using tt instead
"nnoremap <silent><leader>tt <C-w>o :botright sb \!/bin/bash<Tab><CR><C-W>15_<C-w>k


"term window size set to 15 rows, and unchanged col width
"Don't do this because it doesn't allow for intuitive re-sizing 
"set termwinsize=15x0

"exiting vim if terminal is last buffer open
"tnoremap <silent><C-D> <C-D><C-\><C-N>ZQ

" ------------------------- Buffers -----------------------------------
"intelligent :bd - will close buffer but keep window ports the same
nnoremap <leader>q :Bclose<CR>
"switch to last buffer. the reason why I chose 3 is 
"because it is the same button i use to press # for :b#
nmap <leader>3 <C-^>

" :bnext, :bprev normal mode shortcuts
nnoremap ]b :call BnSkipTermForward()<CR>
nnoremap [b :call BnSkipTermBack()<CR>

" ------------------------- Tabs -----------------------------------
nnoremap ]t :tabn<CR>
nnoremap [t :tabp<CR>

" ------------------------- Copy/Paste/Select -----------------------------
"Select all text
nmap <C-a> <esc>ggVG<CR>
"copy to system keyboard
vmap <C-c> "+y
vmap <C-x> "+x
"paste system keyboard
nnoremap <C-v> "+]p
vnoremap <C-v> "+]p<ESC>
inoremap <C-v> q<BS><Esc>"+]p

"paste on new line without losing indent 
nnoremap <expr> <leader>p Has_new_line() ? 'oq<BS><esc>p':'oq<BS><esc>]pk"_dd'
nnoremap <expr> <leader>P Has_new_line() ? 'Oq<BS><Esc>]p':'Oq<BS><esc>]pk"_dd'
"simple paste with indent, does 90% of what the above func does
"noremap <leader>p  oq<BS><Esc>]p
"noremap <leader>P Oq<BS><Esc>]p
 
"print f: surround 'text' with print(f'text: {text}')
nnoremap <leader>f Iprint(f'\n<esc>l"py$A:<space><esc>"pp<esc>Bi{<esc>A}')<esc>^
"
"Create a group by statement when cursor is on table name
nnoremap <leader>gb ISELECT field1, COUNT(*) ct FROM <ESC> oGROUP BY 1<ESC>oHAVING ct > 1;<ESC>2k0 
"
"add markdown link
vnoremap <c-k> s[]<esc>Pla()<esc>"+P

" ------------------------- Code Navigation -------------------------------
"move to method top
map <leader>m ]m
map <leader>M [m
"move to end of method
map <leader>b ]M
map <leader>B [M

" center the first search
cnoremap <expr> <CR> getcmdtype() =~ '[/?]' ? '<CR>zz' : '<CR>'
"update n and N to always go forward and backward after initial search
nnoremap <expr> n (v:searchforward ? 'nzz' : 'Nzz')
nnoremap <expr> N (v:searchforward ? 'Nzz' : 'nzz')
vnoremap <expr> n (v:searchforward ? 'nzz' : 'Nzz')
vnoremap <expr> N (v:searchforward ? 'Nzz' : 'nzz')
nnoremap * *zz
nnoremap # #zz

"open previous commands in new window
nnoremap <C-f> :<C-f>

"g; will center automatically
nnoremap g; g;zz
"
"jump list recenter
nnoremap <C-O> <C-O>zz
nnoremap <C-I> <C-I>zz

"allow mouse navigation
set mouse=a

" ------------------------- Editing Text ----------------------------------
"new line in normal mode
nnoremap <Enter> oq<BS><Esc>Dkl
nnoremap <leader><Enter> Oq<BS><Esc>Djl

"create a space using spacebar in normal mode
nnoremap <space> a<space><Esc>
"when changing case, don't move the cursor
nnoremap ~ ~h
"nnoremap gm gM

" spell check settings
autocmd BufRead,BufNewFile *.md setlocal spell
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>
" open up spell checker recommendations
nnoremap <leader>sc z=

" ------------------------- Editing Files ---------------------------------
if has("win32unix") || has("win32")
		nnoremap <leader>ev :e ~/_vimrc<CR>
		nnoremap <leader>sv :source ~/_vimrc<CR>
else
		nnoremap <leader>ev :e ~/.vimrc<CR>
		nnoremap <leader>sv :source ~/.vimrc<CR>
endif
"edit scratchpad
nnoremap <leader>eb :e ~/.bashrc<CR>
nnoremap <leader>es :e ~/Programming/Playground/buffer<CR>
nnoremap <leader>eq :e ~/Programming/SQL/scratch.sql<CR>
nnoremap <leader>ep :e ~/Programming/Python/scratch.py<CR>
nnoremap <leader>em :e ~/Programming/Markdown/scratch.md<CR>

"--------------- Command mode mappings ------------------
"bash like keys for : command line mode
cnoremap <C-A>        <Home>
cnoremap <C-E>        <End>
"previous and next history
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>
"in bash <C-K> deletes from cursor position to end
"Note that <C-U> is already defined like bash (delete/cut to beginning)
cnoremap <C-K> <C-\>e(strpart(getcmdline(), 0, getcmdpos() - 1))<CR>

"navigating by word, using alt+b and alt+f, like regular bash mappings
"this works unless option meta key is turned on
if has('mac')
	"using the real character generated isntead of alt, per this link:stackoverflow.com/questions/7501092/can-i-map-alt-key-in-vim
	cnoremap ∫ <S-Left>
	cnoremap ƒ <S-Right>
endif
"These don't work on mac, even after using alt as meta key
cnoremap <A-b> <S-Left>
cnoremap <A-f> <S-Right>

" ------------------------- Visual Mode --------------------

"replace words with ctr+r in visual mode
vnoremap <C-r> "hy:%s/<C-r>h//g<left><left>
" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" ------------------------- Search/Replace -----------------
" remove ctrl+m character
nnoremap <leader>rm :%s/<C-V><C-M>//g<CR>

" ------------------------- Misc ----------------------------
"call clean white space func
if has("autocmd")
	autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee,*.sql :call CleanExtraSpaces()
endif

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"turn off auto-commenting behavior
"autocmd FileType * set formatoptions-=cro

"---------------------helper functions
function! VisualSelection(direction, extra_filter) range
		let l:saved_reg = @"
		execute "normal! vgvy"

		let l:pattern = escape(@", "\\/.*'$^~[]")
		let l:pattern = substitute(l:pattern, "\n$", "", "")

		if a:direction == 'gv'
				call CmdLine("Ack '" . l:pattern . "' " )
		elseif a:direction == 'replace'
				call CmdLine("%s" . '/'. l:pattern . '/')
		endif

		let @/ = l:pattern
		let @" = l:saved_reg
endfunction

" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
		let save_cursor = getpos(".")
		let old_query = getreg('/')
		silent! %s/\s\+$//e
		call setpos('.', save_cursor)
		call setreg('/', old_query)
endfun

"if the register contains \n (user used yy), then do ]p simply.
"Else if the register doesn’t contain \n (user did y$), then oq<BS><esc>p
fun! Has_new_line()
	"let reg = getreg('"')
	if getreg('"') !~ '\n'
		return 1
	else
		return 0
	endif
endfunction

function! Is_term_exist()
	"check if terminal exists, if it does open that one, else open new terminal buffer
	if bufname("\!/usr/local/bin/bash") != ""
		return 1
	else
		return 0
	endif
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
		let l:currentBufNum = bufnr("%")
		let l:alternateBufNum = bufnr("#")

		if buflisted(l:alternateBufNum)
				buffer #
		else
				bprev
		endif

		if bufnr("%") == l:currentBufNum
				new
		endif

		if buflisted(l:currentBufNum)
				execute("bwipe ".l:currentBufNum)
		endif
endfunction

"this func needs to be declared before it is called
"slightly modified from: https://stackoverflow.com/questions/3878692/how-to-create-an-alias-for-a-command-in-vim/3879737#3879737
fun! SetupCmdAbbrev(actual, abbrev)
	"creates an abbrev if the abbrev is at start of line
	exec 'cnoreabbrev <expr> '.a:abbrev
			\ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:abbrev.'")'
			\ .'? ("'.a:actual.'") : ("'.a:abbrev.'"))'
endfun

" wrap :cnext/:cprevious and :lnext/:lprevious
" For syntastic move to next error
function! WrapCommand(direction, prefix)
	"@parameter direction: either next or prev
	"@parameter prefix: either c or n, i.e lnext
	if a:direction == "previous"
			try
					execute a:prefix . "previous"
			catch /^Vim\%((\a\+)\)\=:E553/
					execute a:prefix . "last"
			catch /^Vim\%((\a\+)\)\=:E\%(776\|42\):/
			endtry
	elseif a:direction == "next"
			try
					execute a:prefix . "next"
			catch /^Vim\%((\a\+)\)\=:E553/
					execute a:prefix . "first"
			catch /^Vim\%((\a\+)\)\=:E\%(776\|42\):/
			endtry
	endif
endfunction
 
" https://vi.stackexchange.com/questions/21798/how-to-change-local-directory-of-terminal-buffer-whenever-its-shell-change-direc
" change window local working directory
function! Tapi_lcd(bufnum, arglist)
	let winid = bufwinid(a:bufnum)
	let cwd = get(a:arglist, 0, '')
	if winid == -1 || empty(cwd)
		return
	endif
	call win_execute(winid, 'lcd ' . cwd)
endfunction

"https://vi.stackexchange.com/questions/16708/switching-buffers-in-vi-while-skipping-any-terminal-in-vi-8-1
"ignore buffer terminals when doing bnext
function! BnSkipTermForward()
	let start_buffer = bufnr('%')
	bn
	while &buftype ==# 'terminal' && bufnr('%') != start_buffer
		bn
	endwhile
endfunction

function! BnSkipTermBack()
	let start_buffer = bufnr('%')
	bp
	while &buftype ==# 'terminal' && bufnr('%') != start_buffer
		bp
	endwhile
endfunction

"-------------------- abbrev --------------------------

"create a vertical split from existing buffer
call SetupCmdAbbrev('vs\|b', 'vsb')
"sample of how this would be called without function
"cabbrev <expr> vsb (getcmdtype()==':' && getcmdline() =~ '^vsb$')? 'vs \| b' : 'vsb'

"abbrev find command with F
call SetupCmdAbbrev('find', 'F')
"
"abbrev rg -> Rg
call SetupCmdAbbrev('Rg', 'rg')

"set working directory to current file path
call SetupCmdAbbrev('cd %:h', 'cwd')

call SetupCmdAbbrev('call BnSkipTerm()<CR>', 'bn')

"###############################################################
" Plugins
"###############################################################
" Specify a directory for plugins

"vim-plug directions
" 1. place below, Plug 'url'
" 2. source .vimrc
" 3. in vim run ':PlugInstall'
call plug#begin('~/.vim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ycm-core/YouCompleteMe', { 'do': './install.py' }
Plug 'yuttie/comfortable-motion.vim'
Plug 'vim-python/python-syntax'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'vim-syntastic/syntastic'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'whiteinge/diffconflicts'
Plug 'altercation/vim-colors-solarized'
" Initialize plugin system
call plug#end()

"-------------- airline settings
if has('gui_running')
		let g:airline_powerline_fonts = 1
else
	let g:airline_left_sep = '⮀'
	let g:airline_left_alt_sep = '⮁'
	let g:airline_right_sep = '⮂'
	let g:airline_right_alt_sep = '⮃'
endif

set guifont=Hack\ Regular:h11
"color theme
let g:airline_theme='luna'
"show buffer as tabs
let g:airline#extensions#tabline#enabled = 1
"show buffer index
let g:airline#extensions#tabline#buffer_nr_show = 1
"only show file name in buffer tab
let g:airline#extensions#tabline#formatter = 'unique_tail'

"--------------- YCM settings
let g:ycm_python_interpreter_path = ''
let g:ycm_python_sys_path = []
let g:ycm_extra_conf_vim_data = [
	\  'g:ycm_python_interpreter_path',
	\  'g:ycm_python_sys_path'
	\]
let g:ycm_global_ycm_extra_conf = '~/ycm_global_extra_conf.py'
let g:ycm_always_populate_location_list = 1
let g:ycm_server_keep_logfiles = 1
let g:ycm_server_log_level = 'debug'
nnoremap <silent><leader>x :redir @+<CR> :20message <CR> :redir END <CR>
"so scratch window doesn't open
"let g:ycm_autoclose_preview_window_after_insertion = 1
"let g:ycm_autoclose_preview_window_after_completion = 1
"removes preview window altogether
set completeopt-=preview
let g:ycm_auto_hover=''
"map go to command
nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>

"--------------- python syntax settings
let g:python_highlight_all = 1

"--------------- FZF.vim options -----------------------------

"Goes back to the old layout before this: https://github.com/junegunn/fzf/commit/c60ed1758315f0d993fbcbf04459944c87e19a48
let g:fzf_layout = { 'down': '40%' }

":Files config (adding previewer)
command! -bang -nargs=? -complete=dir Files
		\ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)

" ------------ FZF abreviations/ shortcuts
" includes buffers, history, lines, GFiles?, and GFiles (or Files if GFile not avail)

" B auto exapnds to Buffers
call SetupCmdAbbrev('Buffer<CR>', 'B')
" H auto exapnds to History
call SetupCmdAbbrev('History<CR>', 'H')
" :L auto expands to Lines (basically grep all open buffers for text)
call SetupCmdAbbrev('Lines<CR>', 'L')

"Run :Files on git project root if it exists, else run in cwd
function! s:find_git_root()
	return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction
command! ProjectFiles execute 'Files' s:find_git_root()
nnoremap <c-t> :ProjectFiles<CR>
"deprecated: smart way to auto :File or :GFile https://rietta.com/blog/hide-gitignored-files-fzf-vim/
 
" :Rg basic config, the first set of args is for rg, the second for fzf
"color=dark is for fzf highlighting
"delimiter/nth4 see link:https://github.com/junegunn/fzf.vim/issues/421
command! -bang -nargs=* Rg call fzf#vim#grep("rg --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1,
			\ {"dir": s:find_git_root(), 'options': ['--color=dark', '--delimiter=:, --nth=4..']}, <bang>0)

"--------------- Syntastic options ---------------------------------------
"default statusline options, turned off b/c of airline
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"source: https://stackoverflow.com/questions/39897977/can-i-keep-syntastic-from-opening-the-location-list
let g:syntastic_always_populate_loc_list = 1
"disables auto location list window
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
hi SpellBad term=reverse ctermbg=blue
let g:syntastic_python_flake8_args='--ignore=E501,E225,E124,E93,E265,E261,E122,E121,E131'
"move to next error using lnext
nnoremap <silent> <leader>e :call WrapCommand('next', 'l')<CR>

"--------------- yapf options --------------------------------
nnoremap <leader>y mq :0,$!yapf --style='{based_on_style: facebook}'<CR> `q zz

"--------------- sql formatter - NPM library ------------------------------
"nnoremap <leader>sf mq :%! npx sql-formatter --uppercase --language postgresql --lines-between-queries 2<CR> `q zz
nnoremap <leader>sf mq :%! npx sql-formatter --config "/Users/justinwong/.config/sql-formatter/config.json"<CR>

" search and replace
" https://www.evernote.com/l/ApB7RAojmVlDPb0NC35Cag-Ha4OtAJQA47s
nnoremap <leader>sr :%s/set\n /SET/ge <BAR> %s/create\nor/CREATE OR/ge <BAR> %s/@ /@/ge <BAR> %s/\$ /$/ge <BAR> %s,\(\w\)\s\/\s,\1/,ge <BAR> %s,\(\w\)\s\/$,\1/,ge <BAR> %s/select\n\(.*\)distinct/SELECT DISTINCT\r\1/ge <BAR> %s/select\n\s*\(\w*\)\(\n.*from\)/SELECT \1\2/ge <BAR> %s/merge/MERGE/ge <BAR> %s/matched/MATCHED/ge <BAR> %s/= >/=>/ge <BAR> %s/\s\+\(:\+\)\s*/\1/ge<CR><CR> `q

nnoremap <leader>so :call CocAction('diagnosticToggle')<CR>


"--------------- Coc options ---------------------------------------
"set linter popup color
highlight CocFloating ctermbg=2
highlight CocFloating ctermfg=black
"update/fix formatting, sql fix part b
nnoremap <leader>sb :CocCommand sqlfluff.fix --rules L011,L012<CR>
" show error list, sql error
nnoremap <leader>se :CocList diagnostics<CR>

"--------------- JQ Json options -----------------------------
nnoremap <leader>jq :%!jq .<CR>

"--------------- DiffConflicts options -----------------------
" {'gc': 'git conflict', 'gt': git 'theirs', 'gf': 'finalize the diff'}
nnoremap <leader>gc <C-W>o:DiffConflicts<CR>
nnoremap <leader>gt :diffget<CR>
"nnoremap <leader>gf mG:w<CR><C-L>:q<CR>`G
nnoremap <leader>gf :w<CR><C-W>o

"--------------- `Plugin` options ----------------------------

