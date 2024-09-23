open Core
open Olox_lib

let%expect_test "whitespace" = 
"
space    tabs				newlines




end

// expect: IDENTIFIER space null
// expect: IDENTIFIER tabs null
// expect: IDENTIFIER newlines null
// expect: IDENTIFIER end null
// expect: EOF  null
"
|> Interpreter.interpret;
;;
    