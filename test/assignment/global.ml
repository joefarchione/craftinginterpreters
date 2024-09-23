open Core
open Olox_lib

let%expect_test "global" = 
"
var a = \"before\";
print a; // expect: before

a = \"after\";
print a; // expect: after

print a = \"arg\"; // expect: arg
print a; // expect: arg
"
|> Interpreter.interpret;
  [%expect {|
    before
    after
    arg
    arg
    |}]
;;
    