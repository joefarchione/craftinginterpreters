open Core
open Olox_lib

let%expect_test "grouping" = 
"
var a = \"a\";
(a) = \"value\"; // Error at '=': Invalid assignment target.
"
|> Interpreter.interpret;
  [%expect {|
    runtime error: Invalid assignment target '(Grouping
       (Variable { tag = IDENTIFIER; lexeme = "a"; literal = LoxNil; line = 3 }))'
    |}]
;;
    