open Core
open Olox_lib

let%expect_test "this_in_superclass_method" = 
"
class Base {
  init(a) {
    this.a = a;
  }
}

class Derived < Base {
  init(a, b) {
    super.init(a);
    this.b = b;
  }
}

var derived = Derived(\"a\", \"b\");
print derived.a; // expect: a
print derived.b; // expect: b
"
|> Interpreter.interpret;
;;
    