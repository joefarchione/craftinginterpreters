open Core
open Olox_lib

let%expect_test "nested_class" = 
"
class Outer {
  method() {
    print this; // expect: Outer instance

    fun f() {
      print this; // expect: Outer instance

      class Inner {
        method() {
          print this; // expect: Inner instance
        }
      }

      Inner().method();
    }
    f();
  }
}

Outer().method();
"
|> Interpreter.interpret;
;;
    