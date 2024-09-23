open Core
open Olox_lib

let%expect_test "no_superclass_bind" = 
"
class Base {
  foo() {
    super.doesNotExist; // Error at 'super': Can't use 'super' in a class with no superclass.
  }
}

Base().foo();
"
|> Interpreter.interpret;
;;
    