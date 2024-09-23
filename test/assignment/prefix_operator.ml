open Core
open Olox_lib

let%expect_test "prefix_operator" = 
"
var a = \"a\";
!a = \"value\"; // Error at '=': Invalid assignment target.
"
|> Interpreter.interpret;
  [%expect {|
    runtime error: Invalid assignment target '(Unary ({ tag = BANG; lexeme = "!"; literal = LoxNil; line = 3 },
       (Variable { tag = IDENTIFIER; lexeme = "a"; literal = LoxNil; line = 3 })
       ))'
    |}]
;;
    