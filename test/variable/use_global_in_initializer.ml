open Core
open Olox_lib

(*FIXME*)
let%expect_test "use_global_in_initializer" = 
"
var a = \"value\";
var a = a;
print a; // expect: value
"
|> Interpreter.interpret;
  [%expect {| resover error: Already a variable in this scope with name 'a' |}]
;;
    