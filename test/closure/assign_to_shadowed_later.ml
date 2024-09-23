open Core
open Olox_lib

let%expect_test "assign_to_shadowed_later" = 
"
var a = \"global\";

{
  fun assign() {
    a = \"assigned\";
  }

  var a = \"inner\";
  assign();
  print a; // expect: inner
}

print a; // expect: assigned
"
|> Interpreter.interpret;
;;
    