open Core
open Olox_lib

let%expect_test "multiline" = 
"
var a = \"1
2
3\";
print a;
// expect: 1
// expect: 2
// expect: 3
"
|> Interpreter.interpret;
  [%expect {|
    1
    2
    3
    |}];;


;;
    