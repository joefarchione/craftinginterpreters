open Core
open Olox_lib

let%expect_test "associativity" = 
"
var a = \"a\";
var b = \"b\";
var c = \"c\";

// Assignment is right-associative.
a = b = c;
print a; // expect: c
print b; // expect: c
print c; // expect: c
"
|> Interpreter.interpret;
  [%expect {| ccc |}]
;;
    