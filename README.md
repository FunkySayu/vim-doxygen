# Doxygen plugin for Vim


## How to install

Simply create a directory `plugin/doxygen` in your vim configuration folder
(basicly at `$HOME/.vim`) and then put all the `*.vim` files in this folder.


## How to configure

There're some configuration variables for Doxygen module. Here is a listing
of the most importants :

    - `g:DefaultAuthor` : this variable allow you to overpass the input
    "Enter author name : " when you use any doxygen generation.

    - `g:DefaultVersion` : tthis variable allow you to overpass the input
    "Enter version string : " when you use any doxygen generation.

    - `g:Doxygen_maxFunctionProtoLines` : if you have some function with
    a definition of more than 10 lines, you can change this parameter.


## Tags configuration

Here are the variables for tags configuration. Generally there syntax looks
like `g:Doxygen_<tag>Tag` where `<tag>` is the name of the tag. For example,
if you want to change the tag `param` (basicly "@param "), you can define
the variable `let g:Doxygen_paramTag = "/myTagParam "`.

Here is the listing of tags :

    - `g:Doxygen_briefTag` : "@brief "

    - `g:Doxygen_templateParamTag` : "@tparam "

    - `g:Doxygen_paramTag` : "@param "

    - `g:Doxygen_returnTag` : "@return "

    - `g:Doxygen_throwTag` : "@throw "

    - `g:Doxygen_fileTag` : "@file "

    - `g:Doxygen_dateTag` : "@date "

    - `g:Doxygen_versionTag` : "@version "

    - `g:Doxygen_nameTag` : "@name "

    - `g:Doxygen_classTag` : "@class "


## TODO list

    - Check if the function return something before adding the return tag
    - Make this plugin for Java
