open Core
open Olox_lib

let%expect_test "reassign_superclass" = 
"
class Base {
  method() {
    print \"Base.method()\";
  }
}

class Derived < Base {
  method() {
    super.method();
  }
}

class OtherBase {
  method() {
    print \"OtherBase.method()\";
  }
}

var derived = Derived();
derived.method(); // expect: Base.method()
Base = OtherBase;
derived.method(); // expect: Base.method()
"
|> Interpreter.interpret;
;;
    