open Core
open Olox_lib

let%expect_test "local_reference_self" = 
"
{
  class Foo {
    returnSelf() {
      return Foo;
    }
  }

  print Foo().returnSelf(); // expect: Foo
}
"
|> Interpreter.interpret;
  [%expect {| runtime error: return |}]
;;
    