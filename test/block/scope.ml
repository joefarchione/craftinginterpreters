open Core
open Olox_lib

let%expect_test "scope" = 
"
var a = \"outer\";

{
  var a = \"inner\";
  print a; // expect: inner
}

print a; // expect: outer
"
|> Interpreter.interpret;
;;
    