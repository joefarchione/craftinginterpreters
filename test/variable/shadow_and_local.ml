open Core
open Olox_lib

let%expect_test "shadow_and_local" = 
"
{
  var a = \"outer\";
  {
    print a; // expect: outer
    var a = \"inner\";
    print a; // expect: inner
  }
}"
|> Interpreter.interpret;
  [%expect {|
    outer
    inner
    |}]
;;
    