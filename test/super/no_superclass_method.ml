open Core
open Olox_lib

let%expect_test "no_superclass_method" = 
"
class Base {}

class Derived < Base {
  foo() {
    super.doesNotExist(1); // expect runtime error: Undefined property 'doesNotExist'.
  }
}

Derived().foo();
"
|> Interpreter.interpret;
;;
    