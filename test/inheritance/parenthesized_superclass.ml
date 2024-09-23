open Core
open Olox_lib

let%expect_test "parenthesized_superclass" = 
"
class Foo {}

// [line 4] Error at '(': Expect superclass name.
class Bar < (Foo) {}
"
|> Interpreter.interpret;
;;
    