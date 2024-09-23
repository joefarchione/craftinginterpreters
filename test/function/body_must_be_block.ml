open Core
open Olox_lib

let%expect_test "body_must_be_block" = 
"
// [line 3] Error at '123': Expect '{' before function body.
// [c line 4] Error at end: Expect '}' after block.
fun f() 123;
"
|> Interpreter.interpret;
;;
    