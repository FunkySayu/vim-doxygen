" Vim doxygen plugin
" Language:         C, PHP, Python
" Maintainer:       Axel Martin <axel.martin@eisti.fr>
" Last Change:      Jan 28, 2015

" Global constant definitions
if !exists("g:Doxygen_briefTag")
  let g:Doxygen_briefTag = "@brief "
endif
if !exists("g:Doxygen_templateParamTag")
  let g:Doxygen_templateParamTag = "@tparam "
endif
if !exists("g:Doxygen_paramTag")
  let g:Doxygen_paramTag = "@param "
endif
if !exists("g:Doxygen_returnTag")
  let g:Doxygen_returnTag = "@return "
endif
if !exists("g:Doxygen_throwTag")
  let g:Doxygen_throwTag = "@throw "
endif
if !exists("g:Doxygen_fileTag")
  let g:Doxygen_fileTag = "@file "
endif
if !exists("g:Doxygen_authorTag")
  let g:Doxygen_authorTag = "@author "
endif
if !exists("g:Doxygen_dateTag")
  let g:Doxygen_dateTag = "@date "
endif
if !exists("g:Doxygen_versionTag")
  let g:Doxygen_versionTag = "@version "
endif
if !exists("g:Doxygen_nameTag")
  let g:Doxygen_nameTag = "@name "
endif
if !exists("g:Doxygen_classTag")
  let g:Doxygen_classTag = "@class "
endif

" Global parameters
if !exists("g:Doxygen_maxFunctionProtoLines")
  let g:Doxygen_maxFunctionProtoLines = 10
endif

if !exists("g:Doxygen_languageInitialize")
  let g:Doxygen_languageInitialize = {}
endif

" Licence generator
let s:licenceTag = "Copyright (C) {{date}} {{author}} \<enter>\<enter>"
let s:licenceTag = s:licenceTag . "This program is free software; you can redistribute it and/or\<enter>"
let s:licenceTag = s:licenceTag . "modify it under the terms of the GNU General Public Licence\<enter>"
let s:licenceTag = s:licenceTag . "as published by the Free Software Foundation; eitther version 2\<enter>"
let s:licenceTag = s:licenceTag . "of the Licence, or (at your option) any later version.\<enter>\<enter>"
let s:licenceTag = s:licenceTag . "This program is distributed in the hopee that it will be useful,\<enter>"
let s:licenceTag = s:licenceTag . "but WITHOUT ANY WARRANTTY; without even the implied warranty of\<enter>"
let s:licenceTag = s:licenceTag . "MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the\<enter>"
let s:licenceTag = s:licenceTag . "GNU General Public Licence for more details.\<enter>\<enter>"
let s:licenceTag = s:licenceTag . "You should have received a copy of tthe GNU General Public Licence\<enter>"
let s:licenceTag = s:licenceTag . "along with this program; if not, write to the Free Software\<enter>"
let s:licenceTag = s:licenceTag . "Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.\<enter>"


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" @author Axel Martin
" @brief Load specific doxygen definition (comments, parsing string...) for the
"        current language
" @version 0.1
" @date 2015-01-27
" 
" @param language string language to load
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! <SID>Doxygen_LoadFTPlugin( language )
  let l:plugin = expand('<sfile>:p:h') . "ftplugin/" . a:language . ".vim"

  if (!filereadable(l:plugin))
    call s:Doxygen_ErrMsg("No syntax definition found for the file type " . a:language)
    return 0
  endif

  source l:plugin
  return 1
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" @author Axel Martin
" @brief Doxygen initialisation : load the language specific regex and prepare
"        vim to print text
" @version 1.0
" @date 2014-10-17
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! <SID>Doxygen_Initialize()
  if (!exists("g:Doxygen_languageInitialize"))
      let g:Doxygen_languageInitialize = {}
  endif

  if (!has_key(g:Doxygen_languageInitialize, &filetype))
    if (!s:Doxygen_LoadFTPlugin(&filetype))
      return
    endif
  endif

  call g:Doxygen_languageInitialize[&filetype]()

  " Writing parameters backup (indent...)
  let s:commentsBackup = &comments
  let s:cinoptionsBackup = &cinoptions
  let s:timeoutlenBackup = &timeoutlen

  " Preparing easier parameters for Doxygen generation
  let &comments = ""
  let &cinoptions = "c1C1"
  let &timeoutlen = 0
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" @author Axel Martin
" @brief Licence Generation
" @version 1.0
" @date 2014-10-17
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! <SID>Doxygen_LicenceGenFunc()
  call s:Doxygen_Initialize()

  " Test the global author name variable
  if !exists("g:DefaultAuthor")
    let g:DefaultAuthor = input("Enter author name : ")
  endif

  let l:date = strftime("%Y")
  let s:licence = substitute(s:licenceTag, "{{date}}", l:date, "g")
  let s:licence = substitute(s:licence, "{{author}}", g:DefaultAuthor, "g")
  let s:licence = substitute(s:licence, "\<enter>", "\<enter>" . g:Doxygen_interCommentTag, "g")

  if (g:Doxygen_startCommentBlock != "")
    exec "normal O".g:Doxygen_startCommentTag
  endif
  exec "normal o".g:Doxygen_interCommentTag
  exec "normal A".s:licence
  if (g:Doxygen_endCommentBlock != "")
    exec "normal o".g:Doxygen_endCommentTag
  endif

  call s:Doxygen_RestoreParameters()
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" @author Axel Martin
" @brief File header generation
" @version 1.0
" @date 2014-10-17
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! <SID>Doxygen_AuthorGenFunc()
  call s:Doxygen_Initialize()

  " Test the global author name variable
  if !exists("g:DefaultAuthor")
    let g:DefaultAuthtor = input("Enter name of the author : ")
  endif

  if !exists("g:DefaultEmail")
    let g:DefaultEmail = input("Enter the mail of the author : ")
  endif

  if !exists("g:Doxygen_versionString")
    let g:Doxygen_versionString = input("Enter version string : ")
  endif

  let l:fileName = expand("%:t")
  let l:date = strftime("%Y-%m-%d")

  exec "normal O".g:Doxygen_startCommentTag
  exec "normal o".g:Doxygen_interCommentTag.g:Doxygen_fileTag.l:fileName
  exec "normal o".g:Doxygen_interCommentTag.g:Doxygen_authorTag.g:DefaultAuthor." ".g:DefaultEmail
  exec "normal o".g:Doxygen_interCommentTag.g:Doxygen_briefTag
  mark d
  exec "normal o".g:Doxygen_interCommentTag.g:Doxygen_versionTag.g:Doxygen_versionString
  exec "normal o".g:Doxygen_interCommentTag.g:Doxygen_dateTag.l:date
  if (g:Doxygen_endCommentTag != "")
    exec "normal o".g:Doxygen_endCommentTag
  endif

  exec "normal `d"

  call s:Doxygen_RestoreParameters()
  startinsert!
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" @author Axel Martin
" @brief Print an error message
" @version 1.0
" @date 2014-10-17
" 
" @param message message to print
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:Doxygen_ErrMsg(message)
  echohl WarningMsg
  echo a:message
  echohl None
  return
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" @author Axel Martin
" @brief Restore user parameters
" @version 1.0
" @date 2014-10-17
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! <SID>Doxygen_RestoreParameters()
  let &comments = s:commentsBackup
  let &cinoptions = s:cinoptionsBackup
  let &timeoutlen = s:timeoutlenBackup
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" @author Axel Martin
" @brief Automatic doxygen functions comment generator
" @version 1.0
" @date 2014-10-17
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! <SID>Doxygen_CommentFuncGen()
  call s:Doxygen_Initialize()

  mark d

  " First, let's see if there's something to comment
  let l:lineBuffer = getline(line('.'))
  let l:count = 1
  while (match(l:lineBuffer, "^[[:blank:]]*$") != -1 && l:count < 4)
    exec "normal j"
    let l:lineBuffer = l:lineBuffer.' '.getline(line("."))
    let l:count = l:count + 1
  endwhile
  if (match(l:lineBuffer, "^[[:blank:]]*$") != -1)
    call s:Doxygen_ErrMsg("Nothing to document here !")
    exec "normal `d"
    return
  endif
  mark d

  " Now let's seek the function/object prototype
  let l:count = 0
  while (l:count < g:Doxygen_maxFunctionProtoLines)

    " Is it the end of the protoype ?
    if (match(l:lineBuffer, g:Doxygen_endDefinitionRegexp) != -1)
      break
    endif

    let l:count = l:count + 1
    exec "normal j"

    " Deleting comments in the function definition (yes, there're some people who do that)
    if (g:Doxygen_inlineCommentRegexp != "")
      let l:currentLine = substitute(getline(line(".")), g:Doxygen_inlineCommentRegexp, '', '')
    else
      let l:currentLine = getline(line("."))
    endif
    if (g:Doxygen_multilineCommentRegexp != "")
      let l:lineBuffer  = substitute(l:lineBuffer . l:currentLine, g:Doxygen_multilineCommentRegexp, '', '')
    else
      let l:lineBuffer  = l:lineBuffer . l:currentLine
    endif
  endwhile

  if (l:count >= g:Doxygen_maxFunctionProtoLines)
    call s:Doxygen_ErrMsg("Nothing to document here !")
    exec "normal `d"
    return
  endif

  " Let's see what I'm about to document
  let l:type = ""
  for key in keys(g:Doxygen_typesRegexp)
    if (match(l:lineBuffer, g:Doxygen_typesRegexp[key]) != -1)
      let l:type = key
      break
    endif
  endfor
  
  if l:type == ""
    call s:Doxygen_ErrMsg("Unknown type definition")
    exec "normal `d"
    return
  endif

  " Getting futher informations for the type found
  let l:type_keys = {}
  for key in keys(g:Doxygen_typesParticularity[l:type])
    let l:Operation = g:Doxygen_typesParticularity[l:type][key]
    if type(l:Operation) == type("") " type string
      if g:Doxygen_typesParticularity[l:type][key] ==  ''
        let l:type_keys[key] = ""
      else
        let l:type_keys[key] = matchstr(l:lineBuffer, l:Operation)
      endif
    elseif type(l:Operation) == type(function("tr")) " type function 
      let l:type_keys[key] = l:Operation(l:lineBuffer)
    endif
    unlet l:Operation
  endfor

  " Some basics informations
  if !exists("g:DefaultAuthor")
    let g:DefaultAuthor = input("Enter name of the author :")
  endif
  if !exists("g:Doxygen_versionString")
    let g:Doxygen_versionString = input("Enter version string : ")
  endif
  let l:date = strftime("%Y-%m-%d")

  " Print the result !
  exec "normal `d"
  exec "normal O".g:Doxygen_startCommentTag
  exec "normal o".g:Doxygen_interCommentTag.g:Doxygen_authorTag.g:DefaultAuthor
  exec "normal o".g:Doxygen_interCommentTag.g:Doxygen_briefTag
  mark d
  exec "normal o".g:Doxygen_interCommentTag.g:Doxygen_versionTag.g:Doxygen_versionString
  exec "normal o".g:Doxygen_interCommentTag.g:Doxygen_dateTag.l:date
  exec "normal o".g:Doxygen_interCommentTag
  for key in keys(l:type_keys)
    if type(l:type_keys[key]) == type("")
      exec "normal o".g:Doxygen_interCommentTag.key.l:type_keys[key]
    elseif type(l:type_keys[key]) == type([])
      for element in l:type_keys[key]
        exec "normal o".g:Doxygen_interCommentTag.key.element
      endfor
    endif
  endfor
  
  exec "normal o".g:Doxygen_endCommentTag
  exec "normal `d"

  call s:Doxygen_RestoreParameters()
  startinsert!
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Main
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Shortcuts
command! -nargs=0 DoxLic :call <SID>Doxygen_LicenceGenFunc()
command! -nargs=0 DoxAuthor :call <SID>Doxygen_AuthorGenFunc()
command! -nargs=0 Dox :call <SID>Doxygen_CommentFuncGen()

