open Core
open Olox_lib

let%expect_test "whitespace" = 
"
space    tabs				newlines




end

// expect: IDENTIFIER space null
// expect: IDENTIFIER tabs null
// expect: IDENTIFIER newlines null
// expect: IDENTIFIER end null
// expect: EOF  null
"
|> Lexer.scan_text
|> Token.print_tokens;
  [%expect {|
    { tag = IDENTIFIER; lexeme = "space"; literal = LoxNil; line = 2 }

    { tag = IDENTIFIER; lexeme = "tabs"; literal = LoxNil; line = 2 }

    { tag = IDENTIFIER; lexeme = "newlines"; literal = LoxNil; line = 2 }

    { tag = IDENTIFIER; lexeme = "end"; literal = LoxNil; line = 7 }
    |}]
;;
    