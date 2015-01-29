" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" @author Axel Martin
" @brief Spliting des paramètres d'entrées d'une fonction écrite en VimScript
" @version 1.0
" @date 2014-10-17
" 
" @param string chaine de caractère à spliter (définition de la fonction)
" @return liste des paramètres d'entrée de la fonction
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! g:FTVimSplitParameters( string )

  let l:parameters = matchstr(a:string, '\([[:alnum:]_:<>]\+(\)\@<=[[:blank:][:alnum:]_,]*)')
  let l:position   = 0
  let l:result     = []

  let l:param_matcher = '[[:alnum:]_]\+\([[:blank:]]*[),]\)\@='

  while (match(l:parameters, l:param_matcher, l:position) != -1)
    let l:result   += [ matchstr(l:parameters, l:param_matcher, l:position) ]
    let l:position = matchend(l:parameters, l:param_matcher, l:position)
  endwhile
  
  return l:result
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" @author Axel Martin
" @brief Chargement des variables Doxygen pour VimScript
" @version 1.0
" @date 2014-10-17
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! g:FTVimLoadDoxygen()

  " Fonctions de commentaires
  let g:Doxygen_startCommentTag = '"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'
  let g:Doxygen_interCommentTag = '" '
  let g:Doxygen_endCommentTag   = '"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'
  let g:Doxygen_startCommentBlock = '""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'
  let g:Doxygen_endCommentBlock = '"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""'

  " Regexp
  let g:Doxygen_inlineCommentRegexp = '".*$'
  let g:Doxygen_multilineCommentRegexp = ''
  let g:Doxygen_endDefinitionRegexp = 'function![[:blank:]]\+[[:alnum:]:<>_]\+(.*)'
  let g:Doxygen_definitionNameRegexp = '\(^function![[:blank:]]\+\)\@<=[[:alnum:]:<>_]\+'
  let g:Doxygen_typesRegexp = {"function": '.*'}
  
  " Particularity for types
  let g:Doxygen_typesParticularity = {"function": {}}
  let g:Doxygen_typesParticularity["function"][g:Doxygen_paramTag] = function("g:FTVimSplitParameters")
  let g:Doxygen_typesParticularity["function"][g:Doxygen_returnTag] = ''
endfunction


" Référencement du lecteur de syntaxe
if !exists("g:Doxygen_languageInitialize")
  let g:Doxygen_languageInitialize = {}
endif
let g:Doxygen_languageInitialize['vim'] = function('g:FTVimLoadDoxygen')
