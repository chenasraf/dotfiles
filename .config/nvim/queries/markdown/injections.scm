; extends

; Use php_only parser for php fenced code blocks (doesn't require <?php opening tags)
((fenced_code_block
  (info_string
    (language) @_lang)
  (code_fence_content) @injection.content)
  (#eq? @_lang "php")
  (#set! injection.language "php_only"))
