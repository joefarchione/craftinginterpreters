open Core
open Olox_lib

(*FIXME*)
let%expect_test "use_local_in_initializer" = 
"
var a = \"outer\";
{
  var a = a; // Error at 'a': Can't read local variable in its own initializer.
}
"
|> Interpreter.interpret;
  [%expect {| runtime error: a |}]
;;
    