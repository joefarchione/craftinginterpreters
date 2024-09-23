open Core
open Olox_lib

let%expect_test "shadow_local" = 
"
{
  var a = \"local\";
  {
    var a = \"shadow\";
    print a; // expect: shadow
  }
  print a; // expect: local
}
"
|> Interpreter.interpret;
  [%expect {|
    shadow
    local
    |}]
;;
    