open Core
open Olox_lib

let%expect_test "early_bound" = 
"
var a = \"outer\";
{
  fun foo() {
    print a;
  }

  foo(); // expect: outer
  var a = \"inner\";
  foo(); // expect: outer
}
"
|> Interpreter.interpret;
  [%expect {|
    outer
    outer
    |}]
;;
    