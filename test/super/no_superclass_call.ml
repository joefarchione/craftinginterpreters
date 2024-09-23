open Core
open Olox_lib

let%expect_test "no_superclass_call" = 
"
class Base {
  foo() {
    super.doesNotExist(1); // Error at 'super': Can't use 'super' in a class with no superclass.
  }
}

Base().foo();
"
|> Interpreter.interpret;
;;
    