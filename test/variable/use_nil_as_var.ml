open Core
open Olox_lib

let%expect_test "use_nil_as_var" = 
"
// [line 2] Error at 'nil': Expect variable name.
var nil = \"value\";
"
|> Interpreter.interpret;
;;
    