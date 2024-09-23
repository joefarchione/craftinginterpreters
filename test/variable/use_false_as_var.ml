open Core
open Olox_lib

let%expect_test "use_false_as_var" = 
"
// [line 2] Error at 'false': Expect variable name.
var false = \"value\";
"
|> Interpreter.interpret;
;;
    