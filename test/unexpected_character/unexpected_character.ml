open Core
open Olox_lib

let%expect_test "early_return" = 
"
// [line 3] Error: Unexpected character.
// [java line 3] Error at 'b': Expect ')' after arguments.
foo(a | b);
"
|> Interpreter.interpret;
  [%expect {| message='Invalid char' at line 4 for lexeme='|' |}]
;;
    