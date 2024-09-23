open Core
open Olox_lib

let%expect_test "call_other_method" = 
"
class Base {
  foo() {
    print \"Base.foo()\";
  }
}

class Derived < Base {
  bar() {
    print \"Derived.bar()\";
    super.foo();
  }
}

Derived().bar();
// expect: Derived.bar()
// expect: Base.foo()
"
|> Interpreter.interpret;
;;
    