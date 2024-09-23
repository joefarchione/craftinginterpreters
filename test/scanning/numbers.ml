open Core
open Olox_lib

let%expect_test "numbers" = 
"
123
123.456
.456
123.

// expect: NUMBER 123 123.0
// expect: NUMBER 123.456 123.456
// expect: DOT . null
// expect: NUMBER 456 456.0
// expect: NUMBER 123 123.0
// expect: DOT . null
// expect: EOF  null
"
|> Lexer.scan_text
|> Token.print_tokens;
  [%expect {|
    { tag = NUMBER; lexeme = "123"; literal = (LoxNumber 123.); line = 2 }

    { tag = NUMBER; lexeme = "123.456"; literal = (LoxNumber 123.456); line = 3 }

    { tag = DOT; lexeme = "."; literal = LoxNil; line = 4 }

    { tag = NUMBER; lexeme = "456"; literal = (LoxNumber 456.); line = 4 }

    { tag = NUMBER; lexeme = "123."; literal = (LoxNumber 123.); line = 5 }
    |}]
;;
    