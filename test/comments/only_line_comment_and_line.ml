open Core
open Olox_lib

let%expect_test "only_line_comment_and_line" = 
"
// comment
"
|> Interpreter.interpret;
;;
    