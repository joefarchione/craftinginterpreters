open Core
open Olox_lib

let%expect_test "only_line_comment" = 
"
// comment"
|> Interpreter.interpret;
;;
    