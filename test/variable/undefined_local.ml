open Core
open Olox_lib

let%expect_test "undefined_local" = 
"
{
  print notDefined;  // expect runtime error: Undefined variable 'notDefined'.
}
"
|> Interpreter.interpret;
;;
    