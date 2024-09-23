open Core
open Olox_lib

let%expect_test "strings" = 
"
\"\"
\"string\"

// expect: STRING \"\" 
// expect: STRING \"string\" string
// expect: EOF  null"
|> Lexer.scan_text
|> Token.print_tokens;
  [%expect {|
    { tag = STRING; lexeme = "\"\""; literal = (LoxString ""); line = 2 }

    { tag = STRING; lexeme = "\"string\""; literal = (LoxString "string");
      line = 3 }
    |}]
;;
    