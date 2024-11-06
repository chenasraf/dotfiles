" let b:current_syntax = ""
" unlet b:current_syntax
" runtime! syntax/xml.vim
"
" let b:current_syntax = ""
" unlet b:current_syntax
" syntax include @XML syntax/xml.vim
"
" let b:current_syntax = ""
" unlet b:current_syntax
" syntax include @Lua syntax/lua.vim
"
" let b:current_syntax = ""
" unlet b:current_syntax
" syntax region luaCode  start=+<script>+ keepend end=+</script>+  containedin=xmlCdata contains=@Lua
"
" hi link luaCode Comment
" let b:current_syntax = "aardwolfXml"
" original

" runtime! syntax/xml.vim
" let b:current_syntax = ""
" unlet b:current_syntax
" syntax include @Lua syntax/lua.vim
" syntax region luaCode matchgroup=xmlTag start=+<script>+ end=+</script>+ keepend extend containedin=xmlCdataCdata contains=@Lua
" syntax region xmlLuaScript start=+<script\_s\+type=['"]text/lua['"]\_s*>+ end=+</script>+ containedin=xmlCdata contains=@Lua
" let b:current_syntax = "xml"





" Step 1: Include Lua syntax support
syntax include @Lua syntax/lua.vim

" Step 2: Define Lua in <script> for <script type="text/lua">
" Force <script type="text/lua"> to contain CDATA blocks treated as Lua
syntax region xmlLuaScript start=+<script\_s\+type=['"]text/lua['"]\_s*>+ end=+</script>+ contains=xmlCdata,@Lua

" Step 3: Rewrite xmlCdata behavior for this context and make it contain Lua
" Force the CDATA block inside Lua scripts to highlight Lua code
syntax region xmlCdata start=+<!\[CDATA\[+ end=+\]\]>+ contained contains=@Lua
