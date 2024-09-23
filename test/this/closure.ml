open Core
open Olox_lib

let%expect_test "closure" = 
"
class Foo {
  getClosure() {
    fun closure() {
      return this.toString();
    }
    return closure;
  }

  toString() { return \"Foo\"; }
}

var closure = Foo().getClosure();
print closure(); // expect: Foo
"
|> Interpreter.interpret;
;;
    