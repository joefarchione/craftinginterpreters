open Core
open Olox_lib

let%expect_test "local_inherit_self" = 
"
{
  class Foo < Foo {} // Error at 'Foo': A class can't inherit from itself.
}
// [c line 5] Error at end: Expect '}' after block.
"
|> Interpreter.interpret;
;;
    