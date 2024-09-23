open Core
open Olox_lib

let%expect_test "parse" = 
"
// Note: This is just for the expression parsing chapter which prints the AST.
print (5 - (3 - 1)) + -1;
// expect: (+ (group (- 5.0 (group (- 3.0 1.0)))) (- 1.0))
"
|> Interpreter.interpret;
;;
    