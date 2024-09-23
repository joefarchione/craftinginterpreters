open Core
open Olox_lib

let%expect_test "call_same_method" = 
"
class Base {
  foo() {
    print \"Base.foo()\";
  }
}

class Derived < Base {
  foo() {
    print \"Derived.foo()\";
    super.foo();
  }
}

Derived().foo();
// expect: Derived.foo()
// expect: Base.foo()
"
|> Interpreter.interpret;
;;
    