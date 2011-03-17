" Vim syntax file
" Language:	StringTemplate
" Maintainer:	Ken Wenzel <kenwenzel@gmx.net>
" Last Change:	May 30, 2005
" Version:	1
" URL:	--

" check if folding is disabled
if exists("st_no_folding") && st_no_folding == 1
	let b:st_use_folding = 0
else
	let b:st_use_folding = 1
endif

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
	syntax clear
	let b:st_use_folding = 0
elseif exists("b:current_syntax")
	finish
endif

" set delimiters - standards are:
" begin: <
" end:   >
if exists("st_delim_dollar") && st_delim_dollar == 1
	let b:st_delim_start = "\\$"
	let b:st_delim_end = "\\$"
else
	let b:st_delim_start = "<"
	let b:st_delim_end = ">"
endif

" syntactic elements contained in a template
syn cluster 	stElements		contains=stComment,stEscapedDelim,stTag,stConditional,stSpecialChar
" elements contained in left part of template or attribute references
syn cluster	stAttributeElements     contains=stString,stColon,stAnonTL,stCall,stParen,stOperator

" a group in the group file
syn region	stGroup			matchgroup=Keyword start="group\s\+" skip="<<.*>>" end="group.*;"me=s-1 transparent contains=stInterface,stTemplateDefOp,stBody

" template definition in group file
" e.g.: template1(...)
syn match	stInterface		contained "\S\+([^)]*)"

syn match	stColon			contained ":"
syn match	stSemi			contained ";"
syn match	stTemplateDefOp		contained "::="
syn keyword	stContainedKeywords	contained separator

exe 'syn match	stEscapedDelim		contained "\\' . b:st_delim_start . '"'
exe 'syn region	stAttributeRegion	contained start="' . b:st_delim_start . '"ms=s+1 skip="\\' . b:st_delim_end . '" end="' . b:st_delim_end . '\|;"me=s-1 transparent contains=stParen,stParenError,@stAttributeElements'
" attribute reference, template inclusion or template application
exe 'syn region	stTag			start="' . b:st_delim_start . '" skip="\\' . b:st_delim_end . '" end="' . b:st_delim_end . '" contains=stAttributeRegion,stContainedKeywords,stSemi,stString'

syn region	stParen			contained transparent matchgroup=Delimiter start="(" end=")" contains=stAttribute,@stAttributeElements
syn match 	stParenError		contained ")"

" conditional sub-template inclusion
exe 'syn region	stConditional		contained start="' . b:st_delim_start . '\s*if\s*(" end="' . b:st_delim_end . '" contains=stParen,stParenError'
exe 'syn match	stConditional		contained "' . b:st_delim_start . '\s*\%(else\|endif\)\s*' . b:st_delim_end . '"'

" attribute parameter
syn match	stAttribute		contained "[^ =,()]\+\s*="me=e-1

" template reference
exe 'syn match	stCall			contained "[^ =+!' . b:st_delim_start . b:st_delim_end . ':()]\+\s*("me=e-1'

syn match	stOperator		contained "="
syn match	stOperator		contained "+"
syn region	stString		contained start="\"" skip="\\\"" end="\"" oneline

" template body in group file
syn region	stBody			contained matchgroup=Structure start="\"" skip="\\\"" end="\"" oneline transparent contains=@stElements

if b:st_use_folding == 1
	set foldmethod=syntax
	syn region	stBody			contained matchgroup=Structure start="<<" skip="\\>" end=">>" transparent fold contains=@stElements
else
	syn region	stBody			contained matchgroup=Structure start="<<" skip="\\>" end=">>" transparent contains=@stElements
endif

" anonymous template
syn region	stAnonTL		contained matchgroup=Structure start="{" skip="\\}" end="}" contains=@stElements

exe 'syn region stComment		contained start="' . b:st_delim_start . '!" end="!' . b:st_delim_end . '"'
"special characters like: $\ $, $\n$, $\r$, $\t$
exe 'syn match	stSpecialChar		contained "' . b:st_delim_start . '\\[ ntr]' . b:st_delim_end . '"'

" synchronization
syn sync match stSyncGroup grouphere stBody "::="
syn sync minlines=100

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_stringtemplate_syn_inits")
    	if version < 508
        let did_stringtemplate_syn_inits = 1
		command -nargs=+ HiLink hi link <args>
    	else
		command -nargs=+ HiLink hi def link <args>
    	endif
	HiLink stContainedKeywords	Statement
	HiLink stEscapedDelim		Special
	HiLink stInterface		Structure
	HiLink stTemplateDefOp		Structure
	HiLink stColon			Operator
	HiLink stSemi			Operator
    	HiLink stOperator		Operator
    	HiLink stConditional		Conditional
    	HiLink stTag			PreProc
	HiLink stParenError		Error
    	HiLink stComment		Comment
    	HiLink stSpecialChar		Special
    	HiLink stCall			Function
	HiLink stAttribute		Identifier
	delcommand HiLink
endif

let b:current_syntax = "stringtemplate"
