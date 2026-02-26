(bool) @constant.builtin
(type) @type.builtin
(number) @number
(hex_number) @number
(string) @string
(bytes) @string.special
"null" @constant.builtin
(action) @constant.builtin
(path) @module
(comment) @comment
(function_block function_name: (ident) @function)
(call function_name: (ident) @function)
"cloud.firestore" @variable.builtin
"rules_version" @variable.builtin
[
 "match"
 "allow"
 "if"
 "return"
 "function"
 "let"
 "service"
] @keyword
[
 "*"
 "/"
 "+"
 "%"
 "in"
 "is"
 "-"
 ">="
 "<="
 ">"
 "<"
 "=="
 "="
 "!="
 "&&"
 "||"
] @operator
[
 ":"
 ";"
] @punctuation.delimiter
[
 "{"
 "}"
 "["
 "]"
 "("
 ")"
] @punctuation.bracket
