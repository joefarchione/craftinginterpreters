open Core
open Olox_lib

let%expect_test "strings" = 
"
\"\"
\"string\"

// expect: STRING \"\" 
// expect: STRING \"string\" string
// expect: EOF  null"
|> Interpreter.interpret;
;;
    