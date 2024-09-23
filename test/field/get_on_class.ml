open Core
open Olox_lib

let%expect_test "get_on_class" = 
"
class Foo {}
Foo.bar; // expect runtime error: Only instances have properties.
"
|> Interpreter.interpret;
  [%expect {| runtime error: bar |}]
;;
    