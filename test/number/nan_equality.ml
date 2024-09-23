open Core
open Olox_lib

let%expect_test "nan_equality" = 
"
var nan = 0/0;

print nan == 0; // expect: false
print nan != 1; // expect: true

// NaN is not equal to self.
print nan == nan; // expect: false
print nan != nan; // expect: true
"
|> Interpreter.interpret;
;;
    