open Core
open Olox_lib

let%expect_test "closure" = 
"
class Base {
  toString() { return \"Base\"; }
}

class Derived < Base {
  getClosure() {
    fun closure() {
      return super.toString();
    }
    return closure;
  }

  toString() { return \"Derived\"; }
}

var closure = Derived().getClosure();
print closure(); // expect: Base
"
|> Interpreter.interpret;
;;
    