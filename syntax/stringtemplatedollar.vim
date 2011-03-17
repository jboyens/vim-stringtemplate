" Vim syntax file
" Language:	StringTemplate (dollar delimited)
" Maintainer:	Ken Wenzel <kenwenzel@gmx.net>
" Last Change:	May 30, 2005
" Version:	1
" URL:	--

let st_delim_dollar=1
if version < 600
	source $VIMRUNTIME/syntax/stringtemplate.vim
else
	runtime! syntax/stringtemplate.vim
endif
