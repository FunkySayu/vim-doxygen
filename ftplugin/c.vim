" Vim filetype plugin for doxygen plugin
" Language:         C
" Maintainer:       Axel Martin <axel.martin@eisti.fr>
" Last Change:      Jan 28, 2015

" Only do this when not done yet for this buffer
if exists("b:did_doxygen_ftplugin_c")
  finish
endif
let b:did_doxygen_ftplugin_c = 1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" @author Axel Martin
" @brief Spliting des paramètres d'entrées d'une fonction écrite en C
" @version 1.0
" @date 2014-10-17
" 
" @param string chaine de caractère à spliter (définition de la fonction)
" @return liste des paramètres d'entrée de la fonction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! g:Doxygen_FT_C_SplitParameters( string )

  let l:parameters = matchstr(a:string, '\([[:alnum:]_](\)\@<=[[:alnum:][:blank:]_\*,]*)\([[:blank:]]*[;{]\)\@=')
  let l:position   = 0
  let l:result     = []

  let l:param_matcher = '[[:alnum:]_]\+\([,)]\)\@='

  while (match(l:parameters, l:param_matcher, l:position) != -1)
    let l:result   += [ matchstr(l:parameters, l:param_matcher, l:position) ]
    let l:position = matchend(l:parameters, l:param_matcher, l:position)
  endwhile
  
  return l:result
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" @author Axel Martin
" @brief Chargement des variables Doxygen pour C
" @version 1.0
" @date 2014-10-17
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! g:Doxygen_FT_C_Load()

  " Fonctions de commentaires
  let g:Doxygen_startCommentTag = "/** "
  let g:Doxygen_interCommentTag = "* "
  let g:Doxygen_endCommentTag   = "*/"
  let g:Doxygen_startCommentBlock = "/* "
  let g:Doxygen_endCommentBlock = "*/"

  " Regexp
  let g:Doxygen_inlineCommentRegexp = ''
  let g:Doxygen_multilineCommentRegexp = '/\*.*\*/'
  let g:Doxygen_endDefinitionRegexp = '.*;\|{[[:blank:]]*'
  let g:Doxygen_definitionNameRegexp = '\([[:alnum:]_]\+\((.*)[[:blank:]]*[;{]\)\@=\|[[:alnum:]_]\+\([[:blank:]]\+{\)\@=\)'
  let g:Doxygen_typesRegexp = {
        \ "struct": '\(^\(typedef\|static\)[[:blank:]]\+\|^\)\@<=struct\([[:blank:]]\+.*\)\@=',
        \ "enum": '\(^\(typedef\|static\)[[:blank:]]\+\|^\)\@<=struct\([[:blank:]]\+.*\)\@=',
        \ "function": '^\(\(typedef\|static\)\|struct\|enum\)\@![[:alnum:]_\*]\+[[:blank:]]\+[[:alnum:]_\*]\+('
        \ }

  " Particularity for types
  let g:Doxygen_typesParticularity = {
        \ "struct": {},
        \ "enum":   {},
        \ "function": {}
        \ }
  let g:Doxygen_typesParticularity["function"][g:Doxygen_paramTag] = function("g:Doxygen_FT_C_SplitParameters")
  let g:Doxygen_typesParticularity["function"][g:Doxygen_returnTag] = ''
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Main Script
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Référencement du lecteur de syntaxe
if !exists("g:Doxygen_languageInitialize")
  let g:Doxygen_languageInitialize = {}
endif
let g:Doxygen_languageInitialize['cpp'] = function('g:Doxygen_FT_C_Load')
let g:Doxygen_languageInitialize['c']   = function('g:Doxygen_FT_C_Load')
