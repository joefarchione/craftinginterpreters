open Core
open Olox_lib

let%expect_test "in_nested_block" = 
"
{
  var a = \"outer\";
  {
    print a; // expect: outer
  }
}"
|> Interpreter.interpret;
;;
    