open Core
open Olox_lib

let%expect_test "use_this_as_var" = 
"
// [line 2] Error at 'this': Expect variable name.
var this = \"value\";
"
|> Interpreter.interpret;
  [%expect {| message='Expect variable name' at line 3 for lexeme='this' |}]
;;
    