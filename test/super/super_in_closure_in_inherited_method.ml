open Core
open Olox_lib

let%expect_test "super_in_closure_in_inherited_method" = 
"
class A {
  say() {
    print \"A\";
  }
}

class B < A {
  getClosure() {
    fun closure() {
      super.say();
    }
    return closure;
  }

  say() {
    print \"B\";
  }
}

class C < B {
  say() {
    print \"C\";
  }
}

C().getClosure()(); // expect: A
"
|> Interpreter.interpret;
;;
    