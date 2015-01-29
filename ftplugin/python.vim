" Vim filetype plugin for doxygen plugin
" Language:         Python
" Maintainer:       Axel Martin <axel.martin@eisti.fr>
" Last Change:      Jan 28, 2015

" Only do this when not done yet for this buffer
if exists("b:did_doxygen_ftplugin_python")
  finish
endif
let b:did_doxygen_ftplugin_python = 1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" @author Axel Martin
" @brief Spliting des paramètres d'entrées d'une fonction écrite en Python
" @version 1.0
" @date 2014-10-17
" 
" @param string chain de caractère à spliter (définition de la fonction)
" @return liste des paramètres dd'entrée de la fonction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! g:FTPythonSplitParameters( string )
  
  let l:parameters = matchstr(a:string, '\([[:blank:]]*def[[:blank:]]\+[_[:alnum:]]\+(\)\@<=.*\():[[:blank:]]*\)\@=')

  let l:position   = 0
  let l:result     = []

  let l:param_matcher = '\([_[:alnum:]]\+[[:blank:]]*=\@=\|[_[:alnum:]]\+[[:blank:]]*,\@=\|\(,[[:blank:]]*\)\@<=[_[:alnum:]]\+\)'

  while (match(l:parameters, l:param_matcher, l:position) != -1)
    if (matchstr(l:parameters, l:param_matcher, l:position) != "self")
        let l:result   += [ matchstr(l:parameters, l:param_matcher, l:position) ]
    endif
    let l:position = matchend(l:parameters, l:param_matcher, l:position)
  endwhile
  
  return l:result
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" @author Axel Martin
" @brief Chargement des variables Doxygen pour Python
" @version 1.0
" @date 2014-10-17
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! g:FTPythonLoadDoxygen()

  " Fonctions de commentaire
  let g:Doxygen_startCommentTag   = "## "
  let g:Doxygen_interCommentTag   = "# "
  let g:Doxygen_endCommentTag     = "# "
  let g:Doxygen_startCommentBlock = "# "
  let g:Doxygen_endCommentBlock   = "# "

  " Regexp
  let g:Doxygen_inlineCommentRegexp    = '[[:blank:]]*#.*$'
  let g:Doxygen_multilineCommentRegexp = ''
  let g:Doxygen_endDefinitionRegexp    = '\(def\|class\)[[:blank:]]\+[_[:alnum:]]\+(.*):'
  let g:Doxygen_definitionNameRegexp   = '\(def[[:blank:]]\+\|class[[:blank:]]\+\)\@<=[_[:alnum:]]\+'
  let g:Doxygen_typesRegexp = {"function": '^[[:blank:]]*def', "class": '^[[:blank:]]*class'}

  " Particularity for types
  let g:Doxygen_typesParticularity = {
        \ "function": {},
        \ "class": {},
        \ }
  let g:Doxygen_typesParticularity["function"][g:Doxygen_paramTag] = function("g:FTPythonSplitParameters")
  let g:Doxygen_typesParticularity["function"][g:Doxygen_returnTag] = ""
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Main Script
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Référencement du lecteur de syntaxe
if !exists("g:Doxygen_languageInitialize")
  let g:Doxygen_languageInitialize = {}
endif
let g:Doxygen_languageInitialize['python'] = function("g:FTPythonLoadDoxygen")

