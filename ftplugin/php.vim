" Vim filetype plugin for doxygen plugin
" Language:         PHP
" Maintainer:       Axel Martin <axel.martin@eisti.fr>
" Last Change:      Jan 28, 2015

" Only do this when not done yet for this buffer
if exists("b:did_doxygen_ftplugin_php")
  finish
endif
let b:did_doxygen_ftplugin_php = 1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" @author Axel Martin
" @brief Splitting des paramètres d'entrées d'une fonction écrite en PHP
" @version 1.0
" @date 2014-10-17
" 
" @param string chaine de caractère à spliter (définition de la fonction)
" @return liste des paramètres d'entrée de la fonction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! g:FTPHPSplitParameters( string )

  let l:parameters = matchstr(a:string, '\([[:alnum:]_](\)\@<=.*\()[[:blank:]]*{\)\@=')
  let l:position   = 0
  let l:result     = []

  let l:param_matcher = '\(\$\)\@<=[[:alnum:]_]\+'

  while (match(l:parameters, l:param_matcher, l:position) != -1)
    let l:result   += [ matchstr(l:parameters, l:param_matcher, l:position) ]
    let l:position = matchend(l:parameters, l:param_matcher, l:position)
  endwhile
  
  return l:result
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" @author Axel Martin
" @brief Chargement des variables Doxygen pour PHP
" @version 1.0
" @date 2014-10-17
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! g:FTPHPLoadDoxygen()

  " Fonctions de commentaires
  let g:Doxygen_startCommentTag = "/** "
  let g:Doxygen_interCommentTag = "* "
  let g:Doxygen_endCommentTag   = "*/ "
  let g:Doxygen_startCommentBlock = "/* "
  let g:Doxygen_endCommentBlock = "*/"

  " Regexp
  let g:Doxygen_inlineCommentRegexp = '//.*$'
  let g:Doxygen_multilineCommentRegexp = '/\*.*\*/'
  let g:Doxygen_endDefinitionRegexp = '\(class\|function\).*{\(.*\)\@='
  let g:Doxygen_definitionNameRegexp = '\(class[[:blank:]]\+\|function[[:blank:]]\+\)\@<=[[:alnum:]_]\+'
  let g:Doxygen_typesRegexp = {
        \ "class": '^[[:blank:]]*class',
        \ "function": '^[[:blank:]]*\(public[[:blank:]]\|private[[:blank:]]\|protected[[:blank:]]\|\)\(static[[:blank:]]\|\)function.*[{;]'
        \}

  " Particularity for types
  let g:Doxygen_typesParticularity = {
        \ "class": {},
        \ "function": {}
        \}
  let g:Doxygen_typesParticularity["function"][g:Doxygen_paramTag] = function("g:FTPHPSplitParameters")
  let g:Doxygen_typesParticularity["function"][g:Doxygen_returnTag] = ''
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Main Script
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Référencement du lecteur de syntaxe
if !exists("g:Doxygen_languageInitialize")
  let g:Doxygen_languageInitialize = {}
endif
let g:Doxygen_languageInitialize['php'] = function('g:FTPHPLoadDoxygen')

