open Core
open Olox_lib

let%expect_test "shadow_global" = 
"
var a = \"global\";
{
  var a = \"shadow\";
  print a; // expect: shadow
}
print a; // expect: global
"
|> Interpreter.interpret;
  [%expect {|
    shadow
    global
    |}]
;;
    