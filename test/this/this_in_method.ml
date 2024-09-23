open Core
open Olox_lib

let%expect_test "this_in_method" = 
"
class Foo {
  bar() { return this; }
  baz() { return \"baz\"; }
}

print Foo().bar().baz(); // expect: baz
"
|> Interpreter.interpret;
  [%expect {| runtime error: return |}]
;;
    