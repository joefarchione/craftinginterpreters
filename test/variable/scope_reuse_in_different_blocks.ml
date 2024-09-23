open Core
open Olox_lib

let%expect_test "scope_reuse_in_different_blocks" = 
"
{
  var a = \"first\";
  print a; // expect: first
}

{
  var a = \"second\";
  print a; // expect: second
}
"
|> Interpreter.interpret;
;;
    