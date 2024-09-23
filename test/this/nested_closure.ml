open Core
open Olox_lib

let%expect_test "nested_closure" = 
"
class Foo {
  getClosure() {
    fun f() {
      fun g() {
        fun h() {
          return this.toString();
        }
        return h;
      }
      return g;
    }
    return f;
  }

  toString() { return \"Foo\"; }
}

var closure = Foo().getClosure();
print closure()()(); // expect: Foo
"
|> Interpreter.interpret;
  [%expect {| runtime error: return |}]
;;
    