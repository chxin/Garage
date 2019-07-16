" configure plugin list to install
if filereadable(expand("~/.vim/config/.vimrc.plugList"))
	source ~/.vim/config/.vimrc.plugList
endif

" configure vim plugins
if filereadable(expand("~/.vim/config/.vimrc.plugin"))
	source ~/.vim/config/.vimrc.plugin
endif

" configure vim compile source files
if filereadable(expand("~/.vim/config/.vimrc.compile"))
	source ~/.vim/config/.vimrc.compile
endif

" add 'alt' key to shortkey map
if filereadable(expand("~/.vim/config/.vimrc.alt"))
	source ~/.vim/config/.vimrc.alt
endif

" no vi
set nocompatible
set backspace=indent,eol,start
set noshowmode

" encoding
set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8

" show line number 
set number
set relativenumber

" show commond
set showcmd

" set cindent with tab
set smartindent
" set autoindent
filetype plugin indent on
set tabstop=2
set shiftwidth=2

" no fold when startup
set nofoldenable

" hignlight search content
set hlsearch
set incsearch

" ctags
set tags=./.tags;,.tags

" % enhance to highlight content between 'begin' and  'end'
filetype plugin on
syntax on
runtime macros/matchit.vim

" status-line beauty method
" instead by plugin airline
set laststatus=2
" set statusline=
" set statusline +=%1*\ %n\ %*            "buffer number
" set statusline +=%5*%{&ff}%*            "file format
" set statusline +=%3*%y%*                "file type
" set statusline +=%4*\ %<%F%*            "full path
" set statusline +=%2*%m%*                "modified flag
" set statusline +=%1*%=%5l%*             "current line
" set statusline +=%2*/%L%*               "total lines
" set statusline +=%1*%4v\ %*             "virtual column number
" set statusline +=%2*0x%04B\ %*          "character under cursor

" indent for filetype
" another method: ~/.vim/after/ftplugin/*.vim  can take effect when special
" file opened
if has("autocmd")
	filetype on 
	autocmd FileType ruby setlocal ts=2 sts=2 sw=2 et
  autocmd FileType c setlocal ts=4 sts=4 sw=4 et
  autocmd FileType cpp setlocal ts=4 sts=4 sw=4 et
endif

" auto brackets
" inoremap ( ()<ESC>i
" inoremap [ []<ESC>i
" inoremap { {}<ESC>i
" inoremap < <><ESC>i
" inoremap ' ''<ESC>i
" inoremap " ""<ESC>i
